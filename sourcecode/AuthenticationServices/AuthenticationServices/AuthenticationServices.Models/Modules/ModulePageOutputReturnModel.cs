using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
    public class ModulePageOutputReturnModel
    {
        public Guid? ModulePageId { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public string PageName { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsArchived { get; set; }
        public string ModuleName { get; set; }
        public byte[] Timestamp { get; set; }
        public int? LayoutsCount { get; set; }
    }

    public class ModuleLayoutOutputReturnModel
    {
        public Guid? ModulePageId { get; set; }
        public Guid? ModuleLayoutId { get; set; }
        public Guid? ModuleId { get; set; }
        public string LayoutName { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsArchived { get; set; }
        public string ModuleName { get; set; }
        public string PageName { get; set; }
        public byte[] Timestamp { get; set; }
        public int? LayoutsCount { get; set; }
        public int? TotalCount { get; set; }
        
    }
}
