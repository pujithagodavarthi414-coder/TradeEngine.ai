using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
    public class ModuleOutputModel
    {
        public Guid? ModuleId { get; set; }
        public string ModuleName { get; set; }
        public string ModuleLogo { get; set; }
        public string ModuleDescription { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Tags { get; set; }
    }
}
