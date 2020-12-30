$qtdImgs = 5
$folderName = 'fts' 
$url = "https://picsum.photos/200"

function Test-Dir() 
{
   if (Test-Path -Path $folderName) 
   {
      Write-Host "Diretorio já existente."
      return 0 | Out-Null;
   }
   else {
      New-Item $folderName -ItemType "Directory" | Out-Null
      return 1 | Out-Null 
   }  

}

function Read-Logfile() 
{ 
   $logName = 'log.txt'
    
   if ((Test-Path -Path \$logName)) 
   {
      Write-Host "Já existe um arquivo com esse nome"
   }
   else 
   {
      return $logName                        
   }
}


function Get-Host-Ip()
{
   try {
      $ip_request = Invoke-WebRequest 'https://api.ipify.org'    
      return ($ip_request).Content
   }
   catch {
      Write-Host 'É preciso estar conectado a internet para o script funcionar.'
      Exit-PSHostProcess 1
   }
}

function Write-Log()
{
   $dia = Get-Date -Format 'dd/MM/yyyy'
   $hora = Get-Date -Format 'hh:mm'
   $ip = Get-Host-Ip

   Write-Output $dia'; '$hora'; '$ip | Out-File -FilePath $(Read-Logfile)  -Encoding utf8 -Append
}


function Get-Images($photo_name) 
{
   try
   {
      Invoke-WebRequest $url -OutFile "$photo_name.jpeg" | Out-Null
   }
   catch
   {
      Write-Host "Ocorreu um erro ao realizar o download da imagem."
   }
}

for ($i = 0; $i -lt $qtdImgs; $i++)
{
   Get-Images("photo$i")
}
