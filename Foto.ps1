$qtdImgs = 5
$folderName = 'fts' 
$url = "https://picsum.photos/200"
$logName = 'log.txt'

function Test-Or-Create-Dir() 
{
   if (Test-Path -Path $folderName) 
   {
      return 0
   }
   else {
      New-Item $folderName -ItemType "Directory" | Out-Null
      return 0
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

   Write-Output $dia'; '$hora'; '$ip | Out-File -FilePath $logName -Encoding utf8 -Append
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

<#
## EXECUTION
do 
{
   if ($(Test-Or-Create-Dir) -eq 0) 
   {
      Write-Host "Já existe um diretório cujo nome é utilizado pelo processo. Deseja utilizá-lo?" -ForegroundColor Red
      Write-Host "[S/N]: " -NoNewline
      $asw = Read-Host 
      if ($asw -eq 'S' -or $asw -eq 'N') {
         break
      }
      else 
      {
         Write-Host "Opcão Inválida."   
      }
   }
   
} until (0>1)

for ($i = 0; $i -lt $qtdImgs; $i++)
{
   Get-Images("photo$i")
}
#>

