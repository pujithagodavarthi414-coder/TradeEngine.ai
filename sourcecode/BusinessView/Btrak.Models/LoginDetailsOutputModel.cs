using Btrak.Models.CompanyStructure;
using Btrak.Models.MasterData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class LoginDetailsOutputModel
    {
        public string AuthToken { get; set; }
        public Guid? DefaultAppId { get; set; }
        public UserModel UsersModel { get; set; }
        public CompanyOutputModel CompanyDetails { get; set; }
        public List<CompanySettingsSearchOutputModel> CompanySettings { get; set; }
    }

    public class JsonDeserialiseData
    {
        public Object Data { get; set; }
        public List<object> ApiResponseMessages { get; set; }

        public string Result
        {
            get;
            set;
        }

        public bool Success
        {
            get;
            set;
        }

        public string VersionNumber
        {
            get;
            set;
        }

        public bool IsLatestVersion
        {
            get;
            set;
        }
    }
}
