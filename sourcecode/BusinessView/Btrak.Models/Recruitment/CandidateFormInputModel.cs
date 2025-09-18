using Btrak.Models.File;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class CandidateFormInputModel : SearchCriteriaInputModelBase
    {
        public CandidateFormInputModel() : base(InputTypeGuidConstants.CandidateFormInputCommandTypeGuid)
        {
        }

        public string FirstName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string LastName { get; set; }
        public string SecondaryEmail { get; set; }
        public string AddressStreet1 { get; set; }
        public Guid State { get; set; }
        public string ZipCode { get; set; }
        public string AddressStreet2 { get; set; }
        public Guid Country { get; set; }
        public float ExperienceInYears { get; set; }
        public float CurrentSalary { get; set; }
        public float ExpectedSalary { get; set; }
        public string ReferenceEmployeeId { get; set; }
        public string SkypeId { get; set; }
        public string FatherName { get; set; }
        public Guid CurrentDesignation { get; set; }
        public Guid? JobOpeningId { get; set; }
        public List<EducationDetails> EducationDetails { get; set; }
        public List<Experience> Experience { get; set; }
        public List<Skills> Skills { get; set; }
        public List<Documents> Documents { get; set; }
        public List<DocumentsList> DocumentsList { get; set; }
        public List<UploadDocList> UploadResume { get; set; }
        public string EducationDetailsXml { get; set; }
        public string ExperienceXml { get; set; }
        public string SkillsXml { get; set; }
        public string DocumentsXml { get; set; }
        public string UploadedDocumentsXml { get; set; }
        public string UploadedResumeXml { get; set; }
        public string ResumeXml { get; set; }
    }

    public class EducationDetails
    {
        public string Institute { get; set; }
        public string Department { get; set; }
        public string NameOfDegree { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IsPursuing { get; set; }
    }

    public class Experience
    {
        public string OccupationTitle { get; set; }
        public string CompanyName { get; set; }
        public string CompanyType { get; set; }
        public string Description { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string Location { get; set; }
        public bool IsCurrentlyWorkingHere { get; set; }
        public float Salary { get; set; }
    }

    public class Skills
    {
        public Guid SkillName { get; set; }
        public string Experience { get; set; }
    }

    public class Documents
    {
        public string DocumentName { get; set; }
        public string Description { get; set; }
        public Guid DocumentType { get; set; }
        public List<UploadDocList> UploadDocument { get; set; }
    }

    public class DocumentsList
    {
        public string DocumentName { get; set; }
        public string Description { get; set; }
        public Guid DocumentType { get; set; }
        public int Index { get; set; }
    }

    public class UploadDocList
    {
        public string Storage { get; set; }
        public string Name { get; set; }
        public string Url { get; set; }
        public float Size { get; set; }
        public string Type { get; set; }
        public string FileListXml { get; set; }
        public string DocumentName { get; set; }
        public string Description { get; set; }
        public Guid DocumentType { get; set; }
        public List<FileModel> Data { get; set; }
        public string OriginalName { get; set; }
        public List<UploadDocList> UploadResume { get; set; }
    }

    public class UploadedData
    {
        public List<FileModel> FilesList { get; set; }
        public string FilesListXml { get; set; }
        public int Index { get; set; }
    }

}
