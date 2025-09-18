using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrDashboard
{
    public class OrganizationchartOutputModel
    {
        public string Name { get; set; }
        public string Designation { get; set; }
        public string Img { get; set; }
        public Guid? EmployeeId { get; set; }
        public string Color { get; set; }
        public List<OrganizationchartOutputModel> Items { get; set; }
    }

    public class OrganizationchartModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? SelectedEmployeeId { get; set; }
        public Guid? ParentId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string Img { get; set; }
        public string Color { get; set; }
        public List<OrganizationchartOutputModel> Items { get; set; }
    }
}
