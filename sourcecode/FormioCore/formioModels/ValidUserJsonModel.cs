using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
{
    public class ValidUserJsonModel
    {
        public Guid id { get; set; }
        public string firstName { get; set; }
        public string surName { get; set; }
        public string email { get; set; }
        public string fullName { get; set; }
        public bool? isAdmin { get; set; }
        public string profileImage { get; set; }
        public Guid companyId { get; set; }
    }

   
    public class Root
    {
        public ValidUserJsonModel data { get; set; }
        public object modelState { get; set; }
        public List<object> apiResponseMessages { get; set; }
        public object result { get; set; }
        public bool success { get; set; }
        public object versionNumber { get; set; }
        public bool isLatestVersion { get; set; }
    }


}
