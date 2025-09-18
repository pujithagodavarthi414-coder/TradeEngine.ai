using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.SpModels
{
   public class PermissionSpEntity
    {
        public Guid Id
        { get; set; }

        public Guid UserId
        { get; set; }

        public DateTime Date
        { get; set; }

        public DateTime CreatedDateTime
        { get; set; }

        public Guid CreatedByUserId
        { get; set; }

        public DateTime? UpdatedDateTime
        { get; set; }

        public Guid? UpdatedByUserId
        { get; set; }

        public bool? IsMorning
        { get; set; }

        public bool? IsDeleted
        { get; set; }

        public Guid PermissionReasonId
        { get; set; }

        public TimeSpan? Duration
        { get; set; }

        public double? DurationInMinutes
        { get; set; }

    }

    public class PermissionListSpEntity
    {
        public Guid UserId
        { get; set; }

        public DateTime Date
        { get; set; }

        public string EmployeeName
        { get; set; }

        public TimeSpan LateTime
        { get; set; }

        public Guid? PermissionId
        { get; set; }

        public TimeSpan? Duration
        { get; set; }

        public double? DurationInMinutes
        { get; set; }

        public Guid? PermissionReasonId
        { get; set; }

        public string ReasonName
        { get; set; }

        public DateTime? PermissionGivenDate
        { get; set; }

    }
}
