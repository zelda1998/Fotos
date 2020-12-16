$qtdImgs = 5
$folderName = 'fts' 

function Test-Or-Create-Dir() 
{
  <#if((Test-Path -Path pwd\$folderName)){

      Write-Host "Diretorio ja existe"
      return 0;
   }
   else {
      mkdir $folderName   
      return 1; Nao retornava nada, o if passava direto
   }  
   #>
}

function Read-Files-Name() 
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
   $ip = <# depois reparar #>


   Write-Output $dia'; '$hora'; '$ip | Out-File -FilePath $(verifica-arquivo)  -Encoding utf8 -Append
}


function Get-Images() 
{
   if (Test-Or-Create-Dir -ne 0) 
   {
      Set-Location $folderName
      Write-Output "Baixando imagens....."

      for ($i = 0; $i -lt $qtdImgs; $i++) {   
         <#
          # ta dando xabu depois testar
          wget https://picsum.photos/200 -OutFile foto$i.jpeg
          #> 
          Write-Host 'Alvaro macaco'
      }


      Read-Files-Name
      
      Write-Log
      Set-Location '..'

      Write-Output "Imagens baixadas"  
   }
}

Get-Images