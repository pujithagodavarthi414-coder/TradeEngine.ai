using System;

namespace Btrak.Models.HrManagement
{
    public class DocumentTemplateModel
    {
        public Guid? DocumentTemplateId { get; set; }
        public string TemplateName { get; set; }
        public string TemplatePath { get; set; }
        public Guid? SelectedEmployeeId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }

    public class EmployeeReportDetailsModel
    {
        public string EmployeeId { get; set; }
        public string UserId{ get; set; }
        public string FullName{ get; set; }
        public string FirstName{ get; set; }
        public string SurName{ get; set; }
        public string EmployeeNumber{ get; set; }
        public string GenderId{ get; set; }
        public string  MaritalStatusId{ get; set; }
        public string NationalityId{ get; set; }
        public string DateofBirth{ get; set; }
        public string AddressLine1{ get; set; }
        public string AddressLine2{ get; set; }
        public string PostalCode{ get; set; }
        public string StateId{ get; set; }
        public string DesignationId{ get; set; }
        public string DesignationName{ get; set; }
        public string StateName{ get; set; }
        public string CountryId{ get; set; }
        public string CountryName{ get; set; }
        public string PhoneNumber{ get; set; }
        public string Smoker{ get; set; }
        public string MilitaryService{ get; set; }
        public string NickName{ get; set; }
        public string CreatedDateTime{ get; set; }
        public string CreatedByUserId { get; set; }
    }
}
