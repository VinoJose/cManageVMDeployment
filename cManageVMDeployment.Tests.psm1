Get-Module cManageVMDeployment | Remove-Module
Get-Module Hyper-V | Remove-Module
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
    
    Describe 'Testing the Class based DSC resource cManageVMDeployment' {
        
        Context 'Testing the Get() method' {

                    
            $Class = New-PSClassinstance -TypeName cManageVMDeployment

            $Machine = "TestVM"
            $Class.VMName = $Machine
                        
          
            It 'Output type of Get() method should be cManageVMDeployment' {
                
                Mock Get-VM {Return "Some Value"}
                ($Class.Get()).Gettype() | Should be "cManageVMDeployment"

            }        
                    
            It 'Output of Get().VNName' {
                
                Mock Get-VM {Return "Some Value"}
                ($Class.Get()).VMName | Should be $Machine
                    
            }

            It 'Output of Get().Ensure when VM is Present"' {

                Mock Get-VM {Return "Some Value"}            
                ($Class.Get()).Ensure | Should be "Present"
                      
            }
            It 'Output of Get().Ensure when VM is Absent' {

                Mock Get-VM {}            
                ($Class.Get()).Ensure | Should be "Absent"
                      
            }


        }

        Context 'Testing the Set() Method' {
        
            $Class = New-PSClassinstance -TypeName cManageVMDeployment
            $Class.VMName = "TestVM"
            $Class.Ensure = "Present"
            
                        
            It 'Output of Set() method should be $null' {
                mock new-vm {return "something" }
                                
                $Class.Set() | Should be $null
            }

        
        }

        Context 'Testing the Test() Method' {

            $Class = New-PSClassinstance -TypeName cManageVMDeployment
            $Class.VMName = "TestVM"
            $Class.Ensure = "Present"
        
            It 'Output of test() when machine is in Desired state' {
            
                Mock Get-VM {return "Something"}
                $Class.Test() | should be $true   

            }

            It 'Output of test() when machine is not in Desired state' {
            
                Mock Get-VM {}
                $Class.Test() | should be $false   

            }
        
        }
        
        Context 'Testing the CreateVM() method' {
                      
            $Class = New-PSClassinstance -TypeName cManageVMDeployment
            $Class.VMName = "TestVM"

            It 'Output of CreateVM() should be null' {
                
                Mock New-VM {}
                $Class.createVM() | Should be $null
        
            }
                
        }

        Context 'Testing the DeleteVM() method' {
                      
            $Class = New-PSClassinstance -TypeName cManageVMDeployment
            $Class.VMName = "TestVM"

            It 'Output of DeleteVM() should be null' {

                Mock Remove-VM {}
                $Class.DeleteVM() | Should be $null
        
            }
                
        }

        Context 'Testing the TestVM() method' {
                      
            $Class = New-PSClassinstance -TypeName cManageVMDeployment
            $Class.VMName = "TestVM"

            It 'Output of TestVM() when VM is Present' {

                Mock Get-VM {return "something"}   
                $Class.TestVM() | Should be $true
        
            }

            It 'Output of TestVM() when VM is Absent' {

                Mock Get-VM {}   
                $Class.TestVM() | Should be $false
        
            }
                
        } 


    }
}
