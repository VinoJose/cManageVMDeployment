Import-Module "C:\Program Files\WindowsPowerShell\Modules\cManageVMDeployment\cManageVMDeployment.psm1" -Force

InModuleScope cManageVMDeployment {

    function New-PSClassInstance {
    param(
        [Parameter(Mandatory)]
        [String]$TypeName,
        [object[]]$ArgumentList = $null
    )
    $ts = [System.AppDomain]::CurrentDomain.GetAssemblies() |
        Where-Object Location -eq $null | 
            Foreach-Object {
                $_.Gettypes()
            } | Where-Object name -eq $TypeName |
                Select-Object -Last 1
    if($ts) {
        [System.Activator]::CreateInstance($ts,$ArgumentList )
    } else {
        $typeException = New-Object TypeLoadException $TypeName        
        $typeException.Data.Add("ArgumentList",$ArgumentList)
        throw $typeException
    }
    }
    #$class = New-PSClassinstance -TypeName cManageVMDeployment
 
    Describe 'Testing the Class based DSC resource cManageVMDeployment' {

        Context 'Testing the Test() method' {
        
            
            
            $class = New-PSClassinstance -TypeName cManageVMDeployment
            $class.VMName = "test1"
            Function Get-VM {"what is this"}

            It 'Output of Test() should be boolean' {

            #
            Mock Get-VM { $error }
        
            ($class.Get()).Gettype() | Should be cManageVMDeployment

        
            }
    
        }


    }

}

$class = $null