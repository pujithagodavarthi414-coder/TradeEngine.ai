using System;
using System.Collections.Generic;
using System.Text;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.MasterData;

namespace AuthenticationServices.Models.User
{
    public class InitialDetailsOutputModel
    {
        public string AuthToken { get; set; }
        public Guid? DefaultAppId { get; set; }
        public UsersModel UsersModel { get; set; }
        public CompanyOutputModel CompanyDetails { get; set; }
        public List<CompanySettingsSearchOutputModel> CompanySettings { get; set; }
        public UserAuthToken UserAuthToken { get; set; }
    }
}
