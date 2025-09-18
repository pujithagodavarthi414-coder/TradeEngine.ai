using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeInputModel : InputModelBase
    {
        public EmployeeInputModel() : base(InputTypeGuidConstants.EmployeeInputCommandTypeGuid)
        {
        }
        public Guid? EmployeeId { get; set; }
        public Guid? UserId { get; set; }
        public string EmployeeNumber { get; set; }
        public Guid? GenderId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? MaritalStatusId { get; set; }
        public DateTime? MarriageDate { get; set; }
        public Guid? NationalityId { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public bool Smoker { get; set; }
        public bool MilitaryService { get; set; }
        public string NickName { get; set; }
        public Guid? ShiftTimingId { get; set; }
        public bool IsTerminated { get; set; }
        public bool IsArchived { get; set; }
        public bool isActive { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public Guid? JobCategoryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmployeeNumber = " + EmployeeNumber);
            stringBuilder.Append(", GenderId = " + GenderId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", JobCategoryId = " + JobCategoryId);
            stringBuilder.Append(", MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(", NationalityId = " + NationalityId);
            stringBuilder.Append(", DateofBirth = " + DateOfBirth);
            stringBuilder.Append(", Smoker = " + Smoker);
            stringBuilder.Append(", MilitaryService = " + MilitaryService);
            stringBuilder.Append(", NickName = " + NickName);
            stringBuilder.Append(", IsTerminated = " + IsTerminated);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", MarriageDate = " + MarriageDate);
            return stringBuilder.ToString();
        }
    }
}
