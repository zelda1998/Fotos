$qtdImgs = 5
$originalFolder = Get-Location
$folderName = 'fts' 
$url = "https://picsum.photos/200"
$logName = 'log.txt'

function Test-Dir() 
{
   if ($(Test-Path -Path $folderName)) 
   {
      return 1
   }
   else {
      New-Item $folderName -ItemType "Directory" | Out-Null
      return 0
   }  

}

function Get-HostIp() 
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
   $hora = Get-Date -Format 'hh:mm:ss'
   $ip = Get-HostIp

   if($status -eq 1)
   {
      Write-Output "$dia; $hora; $ip; Successful"  | Out-File -FilePath $logName -Encoding utf8 -Append
   }
   else 
   {
      Write-Output "$dia; $hora; $ip; Failed" | Out-File -FilePath $logName -Encoding utf8 -Append
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

function Invoke-Images($ammount) 
{
   Set-Location $folderName

   for ($i = 0; $i -lt $ammount; $i++) 
   {
      Write-Log( $(Get-Image("photo$i")) )
   }
}

function Manage{
   do 
   {
      if ($(Test-Dir) -eq 1) 
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

if ($(Manage) -eq 'S')
{
   Invoke-Images( $qtdImgs )
   Set-Location -Path $originalFolder
}
else 
{
   Write-Host "Terminando o processo..."
   Exit-PSHostProcess 1
}