using System;

namespace Btrak.Models
{
    public class EmployeeWorkConfigurationModel
    {
        public Guid Id
        { get; set; }

        public Guid UserId
        { get; set; }

        public Guid EmployeeId
        { get; set; }

        public string EmployeeName
        { get; set; }

        public decimal MinAllocatedHours
        { get; set; }

        public decimal MaxAllocatedHours
        { get; set; }


        public DateTime ActiveFrom
        { get; set; }

        public DateTime? ActiveTo
        { get; set; }


        public DateTime CreatedDateTime
        { get; set; }

        public Guid CreatedByUserId
        { get; set; }

        public DateTime? UpdatedDateTime
        { get; set; }

        public Guid? UpdatedByUserId
        { get; set; }
    }
}
