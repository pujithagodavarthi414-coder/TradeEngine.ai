using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
    public class ColumnFormatTypeModel
    {
        public Guid? ColumnFormatTypeId { get; set; }
        public string ColumnFormatType { get; set; }
        public int ChildId { get; set; }
        public Guid? ParentId { get; set; }
    }
}
