using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
    public class CompanyModuleOutputModel
    {
        public Guid? CompanyModuleId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? ModuleId { get; set; }
        public string ModuleName { get; set; }
        public string CompanyName { get; set; }
        public int? TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public string ModulePages { get; set; }
        public string Description { get; set; }
        public string ModuleLogo { get; set; }
        public byte[] ModuleTimeStamp { get; set; }
        public string Tags { get; set; }

    }
}
