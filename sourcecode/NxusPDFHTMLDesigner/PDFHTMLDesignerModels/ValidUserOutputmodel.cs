using PDFHTMLDesignerModels.SFDTParameterModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.ValidUserOutputmodel
{
    public class ValidUserOutputmodel
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string FullName { get; set; }
        public bool? IsAdmin { get; set; }
        public string ProfileImage { get; set; }
        public Guid CompanyId { get; set; }
        public string Authorization { get; set; }
    }

    public class AuthUser
    {
        public string RootPath { get; set; }
        public string AuthToken { get; set; }
    }

    public class JsonDeserialiseData
    {
        public Object Data { get; set; }
        public List<ApiResponseMessage> ApiResponseMessages { get; set; }

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
