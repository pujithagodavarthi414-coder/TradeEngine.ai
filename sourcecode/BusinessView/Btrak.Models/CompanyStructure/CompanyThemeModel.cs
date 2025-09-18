using System;

namespace Btrak.Models.CompanyStructure
{
    public class CompanyThemeModel
    {
        public string CompanyThemeString { get; set; }
        public Guid CompanyThemeId { get; set; }
        public string CompanyMainLogo { get; set; }
        public string CompanyMiniLogo { get; set; }
        public string PayslipLogo { get; set; }
        public int IsRemoteSite  { get; set; } 
        public string DefaultLanguage { get; set; }
        public int DefaultLoginWithGoogle { get; set; }
        public string RegistrerSiteAddress { get; set; }
        public string SiteTitle { get; set; }
        public string CompanyName { get; set; }
    }
}