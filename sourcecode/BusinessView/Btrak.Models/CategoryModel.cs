using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class CategoryModel
    {
        public List<Guid> CategoryIds { get; set; }
        public bool? IsAuditElseConduct { get; set; }
        public Guid? ParentCategoryId { get; set; }
    }
}
