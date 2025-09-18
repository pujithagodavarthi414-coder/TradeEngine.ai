using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class SavedCategoriesModel
    {
        public Guid? CategoryId { get; set; }
        public string ParentName { get; set; }
        public string CategoryName { get; set; }
        public int Level { get; set; }
    }
}
