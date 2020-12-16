
$qtdImgs=5

$folderName='fts' 


function verifica-cria-pasta(){

  <#if((Test-Path -Path pwd\$folderName)){
  
      Write-Host "Diretorio ja existe"

      return 0;
      
  
  }
  else{
  
     mkdir $folderName             
  
  }  #>


}

function verifica-arquivo(){ 
    
   $logName='log.txt'
    
   if((Test-Path -Path \$logName)){
   
      Write-Host "Já existe um arquivo com esse nome"
   
   }

   else{
   
      return $logName                        
   
   }

}


function escreve-log(){  

 $dia = Get-Date -Format 'dd/MM/yyyy'
 $hora = Get-Date -Format 'hh:mm'
 $ip = Get-NetIPAddress -AddressFamily IPv4

 echo $dia'; '$hora'; '$ip | Out-File -FilePath $(verifica-arquivo)  -Encoding utf8 -Append

}


function baixa-imagens(){

if(verifica-cria-pasta -ne 0){

cd .\$folderName

   echo "Baixando imagens....."


     for($i=0; $i -lt $qtdImgs; $i++){   
    

        wget https://picsum.photos/200 -OutFile foto$i.jpeg       

    }

 verifica-arquivo  

 escreve-log

 cd..

  echo "Imagens baixadas"  

  }

}

baixa-imagens