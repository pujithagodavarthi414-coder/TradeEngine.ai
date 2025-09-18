using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrManagement
{
    public class EmployeeDetailsHistoryApiInputModel
    {
        public Guid? UserId { get; set; }
        public string Category { get; set; }
        public int PageSize { get; set; }
        public int PageIndex { get; set; }
    }
}
