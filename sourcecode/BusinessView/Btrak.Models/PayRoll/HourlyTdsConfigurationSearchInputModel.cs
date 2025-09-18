using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class HourlyTdsConfigurationSearchInputModel : SearchCriteriaInputModelBase
    {
        public HourlyTdsConfigurationSearchInputModel() : base(InputTypeGuidConstants.HourlyTdsConfigurationSearchInputCommandTypeGuid)
        {
        }
        
        public Guid? BranchId { get; set; }
        public Guid? EmployeeId { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",EmployeeId = " + EmployeeId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
