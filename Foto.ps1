$qtdImgs = 5
$folderName = 'fts' 
$url = "https://picsum.photos/200"
$logName = 'log.txt'

function Test-Dir() 
{
   if (Test-Path -Path $folderName) 
   {
      return 0
   }
   else {
      New-Item $folderName -ItemType "Directory" | Out-Null
      return 1
   }  

}

function Read-Logfile() 
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

function Write-Log($status)
{
   $dia = Get-Date -Format 'dd/MM/yyyy'
   $hora = Get-Date -Format 'hh:mm'
   $ip = Get-Host-Ip
   
   if($status -eq 1)
   {
      Write-Output "$dia'; '$hora'; '$ip; Successful"  | Out-File -FilePath $logName -Encoding utf8 -Append
   }
   else 
   {
      Write-Output "$dia'; '$hora'; '$ip; Failed" | Out-File -FilePath $logName -Encoding utf8 -Append
   }

}

function Get-Image($photo_name) 
{
   $status = 1
   try
   {
      Invoke-WebRequest $url -OutFile "$photo_name.jpeg" | Out-Null
   }
   catch
   {
      Write-Host "Ocorreu um erro ao realizar o download da imagem."
      $status = 0
   }
   
   return $status
}

function Invoke-Get-Image($ammount) 
{
   Set-Location $folderName

   for ($i = 0; $i -lt $ammount; $i++) 
   {
      Get-Image("photo$i")
   }
}

function Manage{
   do 
   {
      if ($(Test-Or-Create-Dir) -eq 0) 
      {
         Write-Host "Já existe um diretório cujo nome é utilizado pelo processo. Deseja utilizá-lo?" -ForegroundColor Red
         Write-Host "[S/N]: " -NoNewline
         $asw = Read-Host 
         if ($asw -eq 'S' -or $asw -eq 'N') 
         {
            return $asw
         }
         else 
         {
            Write-Host "Opcão Inválida."   
         }
      }
      else
      {
         Write-Host "Iniciando downloads... " -ForegroundColor Yellow
         return 'S'
      }
   } while(1)
}

#EXECUTION

if ($(Manage) -eq 'S'){
   Write-Log( $( Invoke-Get-Image( $qtdImgs ) ) )
   Set-Location '..'
}
else 
{
   Write-Host "Terminando o processo..."
   Exit-PSHostProcess 1
}


