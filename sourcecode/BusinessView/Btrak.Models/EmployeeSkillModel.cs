using System;

namespace Btrak.Models
{
   public  class EmployeeSkillModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        public Guid SkillLevelId
        {
            get;
            set;
        }
        public string SkillName
        {
            get;
            set;
        }
        public int? MonthsOfExprience
        {
            get;
            set;
        }
        public string Comments
        {
            get;
            set;
        }
        public DateTime DateFrom
        {
            get;set;
        }
        public DateTime? DateTo
        {
            get; set;
        }
    }
}
