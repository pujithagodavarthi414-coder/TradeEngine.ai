using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
    public class ModulePageUpsertInputModel
    {
        public Guid? ModulePageId { get; set; }
        public Guid? ModuleId { get; set; }
        public string PageName { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsNewPage { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsNameEdit { get; set; }
    }

    public class ModuleLayoutUpsertInputModel
    {
        public Guid? ModulePageId { get; set; }
        public Guid? ModuleLayoutId { get; set; }
        public string LayoutName { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsNameEdit { get; set; }
    }
}
