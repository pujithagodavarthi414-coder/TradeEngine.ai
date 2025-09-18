using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
    public class DynamicModuleUpsertModel 
    {
        public Guid? DynamicModuleId { get; set; }
        public string DynamicModuleName { get; set; }
        public List<DynamicTabs> DynamicTabs { get; set; }
        public string DynamicTabsXML { get; set; }
        public string DynamicTabNames { get; set; }
        public string ViewRole { get; set; }
        public string ViewRoleName { get; set; }
        public string EditRole { get; set; }
        public string EditRoleName { get; set; }
        public bool IsArchived { get; set; }
        public string ModuleIcon { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}


public class DynamicTabs
{
    public Guid? DynamicTabId { get; set; }
    public string DynamicTabName { get; set; }
    public string ViewRole { get; set; }
    public string ViewRoleName { get; set; }
    public string EditRole { get; set; }
    public string EditRoleName { get; set; }
}