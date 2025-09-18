using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class EmployeeSpEntity
    {
        //public Guid UserId { get; set; }
        //public Guid EmployeeId { get; set; }
        //public string FirstName { get; set; }
        //public string Surname { get; set; }
        //public Guid CompanyId { get; set; }
        //public string UserName { get; set; }

        public Guid? Id { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? UserId { get; set; }
        public string EmployeeNumber { get; set; }
        public Guid? GenderId { get; set; }
        public Guid? MaritalStatusId { get; set; }
        public Guid? NationalityId { get; set; }
        public DateTime? DateofBirth { get; set; }
        public bool Smoker { get; set; }
        public bool MilitaryService { get; set; }
        public string NickName { get; set; }
        public bool IsTerminated { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
    }

    public class HrmEmployeeSpEntity
    {
        public Guid EmployeeId { get; set; }
        public string EmployeeNumber { get; set; }
        public Guid CompanyId { get; set; }
        public Guid GenderId { get; set; }
        public Guid MaritalStatusId { get; set; }
        public Guid EmploymentStatusId { get; set; }
        public Guid JobCategoryId { get; set; }
        public Guid NationalityId { get; set; }
        public Guid DepartmentId { get; set; }
        public string FirstName { get; set; }
        public string Gender { get; set; }
        public string MaritalStatus { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
        public string ProfileImage { get; set; }
        public string EmploymentStatus { get; set; }
        public string Department { get; set; }
        public string Designation { get; set; }
        public string JobCategory { get; set; }
        public DateTime? DateofBirth { get; set; }
        public Guid UserId { get; set; }
        public Guid EmployeeLicenceId { get; set; }
        public Guid LicenceTypeId { get; set; }
        public DateTime? IssuedDate { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public string LicenceNumber { get; set; }
    }
}
