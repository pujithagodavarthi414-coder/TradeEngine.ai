using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class EmployeeWebAppUsageTimeOutputModel
    {
        public EmployeeWebAppUsageTimeOutputModel()
        {

        }

        public Guid UserId { get; set; }
        public string Name { get; set; }
        public string ProfileImage { get; set; }
        public Guid? RoleId { get; set; }
        public string ApplicationName { get; set; }
        public string ApplicationTypeName { get; set; }
        public double SpentValue { get; set; }
        public int TotalCount { get; set; }
    }
}
