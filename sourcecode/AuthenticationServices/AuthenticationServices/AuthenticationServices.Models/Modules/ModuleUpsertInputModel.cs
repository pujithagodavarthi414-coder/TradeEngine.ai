using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
    public class ModuleUpsertInputModel
    {
        public Guid? ModuleId { get; set; }
        public Guid? CompanyId { get; set; }
        public string ModuleName { get; set; }
        public string ModuleDescription { get; set; }
        public string ModuleLogo { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public string Tags { get; set; }
    }
}
