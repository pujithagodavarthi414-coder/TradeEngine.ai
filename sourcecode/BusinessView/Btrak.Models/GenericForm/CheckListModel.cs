using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class CheckListModel
    {
        public string ChecklistName { get; set; }
        public string DisplayName { get; set; }
        public string TaskName { get; set; }
        public string Description { get; set; }
        public string TaskOwner { get; set; }
        public string Priority { get; set; }
        public string DueDate { get; set; }
        
    }
}
