using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Employee
{
    public class EmployeeGradeApiOutputModel
    {
        public Guid? EmployeeGradeId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? GradeId { get; set; }
        public string GradeName { get; set; }
        public int GradeOrder { get; set; }
        public Guid? UserId { get; set; }
        public string EmployeeName { get; set; }
        public string ProfileImage { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime ActiveTo { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
