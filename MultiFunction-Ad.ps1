function Show-Menu {
    Write-Host "Please choose an operation:"
    Write-Host "1. AD ThirdDomainer Creation"
    Write-Host "2. Group Membership Mirror"
    Write-Host "3. O365 Account Creation"
    Write-Host "4. Domain Search"
    Write-Host "5. Allow International"
    Write-Host "6. Group-Membership-Add"
    Write-Host "7. Test"
    Write-Host "0. Exit"
}

function AD-ThirdDomainerCreation {
    # Prompt for Domain Controller choice
    $DomainChoice = Read-Host "Please choose the Domain Controller:
1. FirstDomain (First.Domain)
2. SecondDomain (Second.Domain)
3. ThirdDomain (Third.Domain)
4. FourthDomain (Fourth.Domain)
Enter the corresponding number: "

    # Set the Domain Controller based on the ThirdDomainer's choice
    switch ($DomainChoice) {
        1 { $DomainController = "First.Domain" }
        2 { $DomainController = "Second.Domain" }
        3 { $DomainController = "Third.Domain" }
        4 { $DomainController = "Fourth.Domain" }
        default { Write-Host "Invalid choice. Exiting Second.Domainript."; exit }
    }

    # Define the selected domain based on the switch value
    $SelectedDomain = switch ($DomainChoice) {
        1 { "First.Domain.local" }
        2 { "Second.Domain.local" }
        3 { "Third.Domain.local" }
        4 { "FourthDomain.com" }
    }

    # Prompt ThirdDomainer for domain credentials
    $Credential = Get-Credential -Message "Enter your domain credentials for $($SelectedDomain)"

    # Interactive ThirdDomainer creation
    $FirstName = Read-Host "Enter ThirdDomainer's first name:"
    $LastName = Read-Host "Enter ThirdDomainer's last name:"
    $ThirdDomainername = Read-Host "Enter desired ThirdDomainername:"
    $DisplayName = Read-Host "Enter ThirdDomainer's display name:"
    $Password = Read-Host "Enter password" -AsSecureString

    # Retrieve a list of OThirdDomain with "ThirdDomainer" in the name from a specific parent OU
    $ParentOU = "OU=Administration,OU=Corporate,DC=$($SelectedDomain -replace '\.', ',DC=')"
    $OThirdDomain = Get-ADOrganizationalUnit -Filter { Name -like "*ThirdDomainer*" } -SearchBase $ParentOU -Server $DomainController | Select-Object DistinguishedName

    # Display available OThirdDomain with "ThirdDomainer" in the name to the ThirdDomainer
    Write-Host "Available Organizational Units with 'ThirdDomainer' in the name:"
    for ($i = 0; $i -lt $OThirdDomain.Count; $i++) {
        $ouName = ($OThirdDomain[$i].DistinguishedName -split ",", 2)[0] -replace "OU=", ""
        Write-Host "$($i + 1). $ouName"
    }

    # Prompt ThirdDomainer to choose an OU
    $OUChoice = Read-Host "Enter the corresponding number for the target Organizational Unit:"
    $SelectedOU = $OThirdDomain[$OUChoice - 1].DistinguishedName

    # Additional ThirdDomainer details
    $Office = Read-Host "Enter ThirdDomainer's Cost Center:"
    $DeSecond.Domainription = Read-Host "Enter ThirdDomainer's deSecond.Domainription:"
    $Email = Read-Host "Enter ThirdDomainer's email address:"

    # Prompt for Reporting Manager's name
    $ReportingManager = Read-Host "Enter Reporting Manager's name:"

    # Create AD ThirdDomainer ThirdDomaining New-ADThirdDomainer cmdlet
    New-ADThirdDomainer -Name "$FirstName $LastName" `
        -SamAccountName $ThirdDomainername `
        -GivenName $FirstName `
        -Surname $LastName `
        -ThirdDomainerPrincipalName "$ThirdDomainername@$SelectedDomain" `
        -AccountPassword $Password `
        -Enabled $true `
        -Path $SelectedOU `
        -Server $DomainController `
        -Office $Office `
        -DeSecond.Domainription $DeSecond.Domainription `
        -EmailAddress $Email `
        -DisplayName $DisplayName `
        -Credential $Credential
    
    Show-Menu
}

function Group-MembershipMirror {
    # Prompt for Domain Controller choice
    $DomainChoice = Read-Host "Please choose the Domain Controller:
1. FirstDomain (First.Domain)
2. Second.Domain (Second.Domain)
3. ThirdDomain (Third.Domain)
4. FourthDomain (Fourth.Domain)
Enter the corresponding number: "

    # Set the Domain Controller based on the ThirdDomainer's choice
    switch ($DomainChoice) {
        1 { $DomainController = "First.Domain" }
        2 { $DomainController = "Second.Domain" }
        3 { $DomainController = "Third.Domain" }
        4 { $DomainController = "Fourth.Domain" }
        default { Write-Host "Invalid choice. Exiting Second.Domainript.", Exit }
    }

    # Define the selected domain based on the switch value
    $SelectedDomain = switch ($DomainChoice) {
        1 { "First.Domain.local" }
        2 { "Second.Domain.local" }
        3 { "Third.Domain.local" }
        4 { "FourthDomain.com" }
    }

    # Construct the Parent OU path with the selected domain
    $ParentOU = "OU=Administration,OU=Corporate,DC=$($SelectedDomain -replace '\.', ',DC=')"

    # Prompt the ThirdDomainer for domain credentials
    $Credential = Get-Credential -Message "Enter your domain credentials"

    # Prompt the ThirdDomainer for the domain login of the primary ThirdDomainer
    $PrimaryDomainLogin = Read-Host "Enter the primary ThirdDomainer's domain login (ThirdDomainerPrincipalName): "

    # Search for the primary ThirdDomainer in Active Directory
    try {
        $PrimaryThirdDomainer = Get-ADThirdDomainer -Credential $Credential -Filter {
            SamAccountName -eq $PrimaryDomainLogin -or
            ThirdDomainerPrincipalName -eq $PrimaryDomainLogin
        } -Server $DomainController -Properties MemberOf -ErrorAction Stop
    }
    catch {
        Write-Host "Primary ThirdDomainer not found or an error occurred: $($_.Exception.Message)"
        Show-Menu
    }

    # Display the groups that the primary ThirdDomainer is a member of
    Write-Host "Primary ThirdDomainer is a member of the following groups:"
    $PrimaryThirdDomainerGroups = @()
    foreach ($group in $PrimaryThirdDomainer.MemberOf) {
        $groupName = (Get-ADGroup $group).Name
        Write-Host $groupName
        $PrimaryThirdDomainerGroups += $group
    }

    # Define the names of groups to exclude
    $excludedGroups = @("M365 E3 ThirdDomainers", "TX-Sys-GeneralVPNgrp", "Domain ThirdDomainers", "Duo-RDPThirdDomainers")

    # Filter out excluded groups from the primary ThirdDomainer's group memberships
    $filteredGroups = $PrimaryThirdDomainerGroups | Where-Object { $excludedGroups -notcontains (Get-ADGroup $_).Name }

    # Prompt the ThirdDomainer for the domain login of the secondary ThirdDomainer
    $SecondaryDomainLogin = Read-Host "Enter the secondary ThirdDomainer's domain login (ThirdDomainerPrincipalName): "

    # Search for the secondary ThirdDomainer in Active Directory
    try {
        $SecondaryThirdDomainer = Get-ADThirdDomainer -Credential $Credential -Filter {
            SamAccountName -like $SecondaryDomainLogin -or
            ThirdDomainerPrincipalName -like $SecondaryDomainLogin
        } -Server $DomainController -ErrorAction Stop
    }
    catch {
        Write-Host "Secondary ThirdDomainer not found or an error occurred: $($_.Exception.Message)"
    }

    # Add the filtered group memberships to the secondary ThirdDomainer
    $groupsWithError = @()
    foreach ($group in $filteredGroups) {
        try {
            Add-ADGroupMember -Identity $group -Members $SecondaryThirdDomainer -Credential $Credential -ErrorAction Stop
        }
        catch {
            $groupsWithError += (Get-ADGroup $group).Name
        }
    }

    # Display the error message and list of groups with errors
    if ($groupsWithError.Count -gt 0) {
        Write-Host "The following groups had errors when adding the secondary ThirdDomainer:"
        foreach ($groupName in $groupsWithError) {
            Write-Host $groupName
        }
    }
    else {
        Write-Host "Group memberships from the primary ThirdDomainer (excluding excluded groups) have been added to the secondary ThirdDomainer."
    }

    #Show Menu
    Show-Menu
}

function O365-AccountCreation {
    # Define the credential
    $Credentials = Get-Credential

    # Prompt for the ConnectionURI choice
    $ConnectionChoice = Read-Host "Please choose the ConnectionURI:
1. xxx-exch-mgmt1.F.localirst.Domain
2. Second.Domain.local
Enter Third.Domaing number: "

    # Set the ConnectionURI based on the ThirdDomainer's choice
    switch ($ConnectionChoice) {
        1 { $ConnectionURI = "http://xxx-exch-mgmt1.First.Domain/Pow.localerShell/" }
        2 { $ConnectionURI = "http://xxx-EXCH-MGMT2.Second.Domain.localowerShell/" }
        default { Write-Host "Invalid choice. Exiting Second.DomainriptThird.Domaint }
    }

    # Establish a remote PowerShell session to Exchange server
    $ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication Kerberos -Credential $Credentials
    Import-PSSession $ExchangeSession -AllowClobber

    # Prompt for the ThirdDomainername
    $sAMAccountName = Read-Host "Please enter the ThirdDomainername"

    # Prompt for Domain Controller choice
    $DomainChoice = Read-Host "Please choose the Domain Controller:
1. FirstDomain (First.Domain)
2. SecondDomain (Second.Domain)
3. ThirdDomain (Third.Domain)
4. FourthDomain (Fourth.Domain)
Enter the corresponding number: "

    # Set the Domain Controller based on the ThirdDomainer's choice
    switch ($DomainChoice) {
        1 { $DomainController = "First.Domain" }
        2 { $DomainController = "Second.Domain" }
        3 { $DomainController = "Third.Domain" }
        4 { $DomainController = "Fourth.Domain" }
        default { Write-Host "Invalid choice. Exiting Second.Domainript."; exit }
    }

    # Filter for exact match of sAMAccountName
    $filter = "sAMAccountName -eq '$sAMAccountName'"

    # Get the ThirdDomainer with exact sAMAccountName match
    $ThirdDomainer = Get-ADThirdDomainer -Filter $filter -Server $DomainController

    # If a ThirdDomainer was found, prompt for email address and execute the command
    if ($ThirdDomainer) {
        $Emailaddress = Read-Host "Please enter ThirdDomainer Email Address"
        Enable-RemoteMailbox -Identity $ThirdDomainer.DistinguishedName -DomainController $DomainController -PrimarySmtpAddress $Emailaddress -RemoteRoutingAddress $Emailaddress
    }
    else {
        Write-Host "ThirdDomainer with sAMAccountName '$sAMAccountName' not found."
    }

    # Remove the remote PowerShell session
    Remove-PSSession $ExchangeSession

    # Show menu
    Show-Menu

}

function Domain-Search {
    # List of domain controllers in different domains along with their credentials
    $DomainControllers = @(
        @{
            Controller = "Fi.localrst.Domain"
            Second.Domain.locall -Message "Enter credentials for Third.Domain },
        @{
            Controller = "Second.Domain.xxx.local"
            Credential = Get-Credential -Message "Enter credentials for Second.Domain"
        },
        @{
            Controller = "FourthDomain.com"
            Credential = Get-Credential -Message "Enter credentials for FourthDomain"
        },
        @{
            Controller = "ThirdDomain.xxx.local"
            Credential = Get-Credential -Message "Enter credentials for ThirdDomain"
        }
    )

    # Prompt for First and Last name
    $FirstName = Read-Host "Enter the First Name"
    $LastName = Read-Host "Enter the Last Name"

    # Loop through each domain controller
    foreach ($DC in $DomainControllers) {
        try {
            # Query Active Directory for ThirdDomainer accounts matching the First and Last name
            $ThirdDomainers = Get-ADThirdDomainer -Filter { (GivenName -eq $FirstName) -and (Surname -eq $LastName) } -Server $DC.Controller -Credential $DC.Credential -ErrorAction Stop

            if ($ThirdDomainers) {
                Write-Host "ThirdDomainers found in $($DC.Controller):"
                foreach ($ThirdDomainer in $ThirdDomainers) {
                    Write-Host "ThirdDomainer Properties:"
                    $ThirdDomainer | Format-List *
                }
            }
            else {
                Write-Host "No ThirdDomainers found in $($DC.Controller)."
            }
        }
        catch {
            Write-Host "Error occurred while querying $($DC.Controller): $_"
        }
    }

    # Show menu
    Show-Menu

}

function Allow-International {
    # Import Active Directory PowerShell module
    Import-Module ActiveDirectory

    # Prompt for Domain Controller choice
    $DomainChoice = Read-Host "Please choose the Domain Controller:
1. FirstDomain (First.Domain)
2. Second.Domain (Second.Domain)
3. ThirdDomain (Third.Domain)
4. FourthDomain (Fourth.Domain)
Enter the corresponding number: "

    # Set the Domain Controller based on the ThirdDomainer's choice
    switch ($DomainChoice) {
        1 { $DomainController = "First.Domain" }
        2 { $DomainController = "Second.Domain" }
        3 { $DomainController = "Third.Domain" }
        4 { $DomainController = "Fourth.Domain" }
        default { Write-Host "Invalid choice. Exiting Second.Domainript."; exit }
    }

    # Define the selected domain based on the switch value
    $SelectedDomain = switch ($DomainChoice) {
        1 { "First.Domain.local" }
        2 { "Second.Domain.local" }
        3 { "Third.Domain.local" }
        4 { "FourthDomain.com" }
    }

    # Prompt ThirdDomainer for domain credentials
    $Credential = Get-Credential -Message "Enter your domain credentials for $($SelectedDomain)"

    # Prompt ThirdDomainer for input
    $NewTimeSpan = Read-Host "Enter the number of days for New-TimeSpan"
    $Members = Read-Host "Enter the ThirdDomainer account to add to the group"

    # Create a TimeSpan object with the specified number of days
    $TimeSpan = New-TimeSpan -Days $NewTimeSpan

    # Add the ThirdDomainer to the specified AD group with the given TimeSpan and provided credentials
    Add-ADGroupMember -Server $DomainController -Identity "Block Logins from Undesirable Countries-Excluded" -Members $Members -MemberTimeToLive $TimeSpan -Credential $Credential

    # Show a menu
    Show-Menu

}

function Group-Membership-Add {

    $DomainChoice = Read-Host "Please choose the Domain Controller:
    1. FirstDomain (First.Domain)
    2. Second.Domain (Second.Domain)
    3. ThirdDomain (Third.Domain)
    4. FourthDomain (Fourth.Domain)
    Enter the corresponding number: "
    
    switch ($DomainChoice) {
        1 { $DomainController = "First.Domain"; $Domain = "First.Domain.local" }
        2 { $DomainController = "Second.Domain"; $Domain = "Second.Domain.locall" }
        3 { $DomainController = "Third.Domain"; $Domain = "Third.Domain.local" }
        4 { $DomainController = "Fourth.Domain"; $Domain = "FourthDomain.com" }
        default { Write-Host "Invalid choice. Exiting Second.Domainript."; exit }
    }
    
    $Credential = Get-Credential -Message "Enter your domain credentials for $($DomainController)"
    
    $searchQuery = Read-Host "Enter a search term for group names:"
    $SearchThirdDomainers = Read-Host "Enter ThirdDomainer to search"
    
    $groups = Get-ADGroup -Filter * -Server $DomainController -Credential $Credential
    
    $ThirdDomainers = Get-ADThirdDomainer -Filter {SamAccountName -eq $SearchThirdDomainers} -Server $DomainController -Credential $Credential
    
    if ($ThirdDomainers) {
        Write-Host "ThirdDomainers found in $($DC.Controller):"
        foreach ($ThirdDomainer in $ThirdDomainers) {
            Write-Host "ThirdDomainer Properties:"
            $ThirdDomainer | Format-List *}
        } else {
        Write-Host "No ThirdDomainer found matching '$SearchThirdDomainers' in $($DomainController)."
        return
    }
    
    Write-Host "List of groups in $($DomainController):"
    $matchingGroups = @()
    foreach ($group in $groups) {
        if ($group.Name -like "*$searchQuery*") {
            $matchingGroups += $group
            Write-Host "$($matchingGroups.Count). $($group.Name)"
        }
    }
    
    if ($matchingGroups.Count -eq 0) {
        Write-Host "No groups found matching '$searchQuery' in $($DomainController)."
        return
    }
    
    $groupNumberToAdd = Read-Host "Enter the group number to add the ThirdDomainer to:"
    if ($groupNumberToAdd -ge 1 -and $groupNumberToAdd -le $matchingGroups.Count) {
        $selectedGroup = $matchingGroups[$groupNumberToAdd - 1]
        $memberOf = Get-ADGroupMember -Identity $selectedGroup | Select-Object -ExpandProperty SamAccountName
            if ($memberOf -contains $ThirdDomainer.SamAccountName) {
                Write-Host "ThirdDomainer $($ThirdDomainer.Name) is already a member of group $($selectedGroup.Name)."
            } else {
            $addToGroupChoice = Read-Host "ThirdDomainer $($ThirdDomainer.Name) is not a member of group $($selectedGroup.Name). Do you want to add them? (Y/N):"
            if ($addToGroupChoice -eq "Y" -or $addToGroupChoice -eq "y") {
                Add-ADGroupMember -Identity $selectedGroup -Members $ThirdDomainer.DistinguishedName
                Write-Host "ThirdDomainer $($ThirdDomainer.Name) added to group $($selectedGroup.Name)."
            } else {
                Write-Host "ThirdDomainer $($ThirdDomainer.Name) was not added to group $($selectedGroup.Name)."
            }
        }
    } else {
        Write-Host "Invalid group number. Exiting Second.Domainript."
    }
    Show-Menu
} 

function Test {

}

Show-Menu

while ($true) {
    $OperationChoice = Read-Host "Enter the corresponding number: "

    switch ($OperationChoice) {
        1 { AD-ThirdDomainerCreation }
        2 { Group-MembershipMirror }
        3 { O365-AccountCreation }
        4 { Domain-Search }
        5 { Allow-International }
        6 { Group-Membership-Add }
        7 { Test }
        0 { Exit-Second.Domainript }
        default { Write-Host "Invalid choice." }
    }
}
