Import-Module SitecoreInstallFramework
$prefix = "thanachart.sc902.local"
$PSScriptRoot = "G:\Sitecore\Sitecore902\XP0 Configuration files 9.0.2 rev. 180604"
$XConnectCollectionService = "$prefix.xconnect"
$sitecoreSiteName = $prefix
$SolrUrl = "https://localhost:8983/solr"
$SolrRoot = "G:\solr-6.6.2"
$SolrService = "solr662"
$SqlServer = "DESKTOP-BQID650\MSSQLSERVER2016"
$SqlAdminUser = "sa"
$SqlAdminPassword="mirum@2019"

#install client certificate for xconnect
$certParams = @{
Path = "$PSScriptRoot\xconnect-createcert.json"
CertificateName = "$prefix.xconnect_client"
}
Install-SitecoreConfiguration @certParams -Verbose
#install solr cores for xdb
$solrParams = @{
Path = "$PSScriptRoot\xconnect-solr.json"
SolrUrl = $SolrUrl
SolrRoot = $SolrRoot
SolrService = $SolrService
CorePrefix = $prefix
}
Install-SitecoreConfiguration @solrParams
#deploy xconnect instance
$xconnectParams = @{
Path = "$PSScriptRoot\xconnect-xp0.json"
Package = "G:\Sitecore\Sitecore902\Sitecore 9.0.2 rev. 180604 (OnPrem)_xp0xconnect.scwdp.zip"
LicenseFile = "G:\Sitecore\license.xml"
Sitename = $XConnectCollectionService
XConnectCert = $certParams.CertificateName
SqlDbPrefix = $prefix
SqlServer = $SqlServer
SqlAdminUser = $SqlAdminUser
SqlAdminPassword = $SqlAdminPassword
SolrCorePrefix = $prefix
SolrURL = $SolrUrl
}
Install-SitecoreConfiguration @xconnectParams
#install solr cores for sitecore
$solrParams = @{
Path = "$PSScriptRoot\sitecore-solr.json"
SolrUrl = $SolrUrl
SolrRoot = $SolrRoot
SolrService = $SolrService
CorePrefix = $prefix
}
Install-SitecoreConfiguration @solrParams
#install sitecore instance
$sitecoreParams = @{
Path = "$PSScriptRoot\sitecore-XP0.json"
Package = "G:\Sitecore\Sitecore902\Sitecore 9.0.2 rev. 180604 (OnPrem)_single.scwdp.zip"
LicenseFile = "G:\Sitecore\license.xml"
SqlDbPrefix = $prefix
SqlServer = $SqlServer
SqlAdminUser = $SqlAdminUser
SqlAdminPassword = $SqlAdminPassword
SolrCorePrefix = $prefix
SolrUrl = $SolrUrl
XConnectCert = $certParams.CertificateName
Sitename = $sitecoreSiteName
XConnectCollectionService = "https://$XConnectCollectionService"
}
Install-SitecoreConfiguration @sitecoreParams
