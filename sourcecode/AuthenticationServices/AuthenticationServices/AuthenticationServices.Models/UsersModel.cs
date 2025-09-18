using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace AuthenticationServices.Models
{
    public class UsersModel
    {
        public UsersModel()
        {
            UserProjects = new List<UserProjects>();
            AssignedIssues = new List<Issues>();
            ReportedIssues = new List<Issues>();
            Members = new List<MembersModel>();
        }

        public Guid Id
        {
            get;
            set;
        }
        public string UserLanguage
        {
            get;
            set;
        }
        public string CompanyLanguage
        {
            get;
            set;
        }
        public Guid? TimeZoneId { get; set; }
        public string TimeZoneOffset { get; set; }
        public string TimeZoneTitle { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public string TimeZone { get; set; }
        public int OffsetMinutes { get; set; }
        public string CurrentTimeZoneOffset { get; set; }
        public string CurrentTimeZoneAbbr { get; set; }
        public string CurrentTimeZoneName { get; set; }
        public Guid? UserReferenceId { get; set; }
        public Guid LoggedUserId
        {
            get;
            set;
        }

        public string LoggedUserName
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please enter a name.")]
        public string FirstName
        {
            get;
            set;
        }

        public Guid OriginalId
        {
            get; set;
        }

        [Required(ErrorMessage = "Please enter a sur name.")]
        public string SurName
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please enter an email address.")]
        [RegularExpression(@"^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$", ErrorMessage = "Please enter a valid email address.")]
        public string UserName
        {
            get;
            set;
        }

        [DataType(DataType.Password)]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 8)]
        //[RequiredIf("Id == 0", ErrorMessage = "Please enter a password.")]
        public string Password
        {
            get;
            set;
        }

        public string RoleName
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please select a role.")]
        //public Guid RoleId
        //{
        //    get;
        //    set;
        //}


        public string BranchName
        {
            get;
            set;
        }

        public Guid? BranchId
        {
            get;
            set;
        }

        public bool IsActive
        {
            get;
            set;
        }

        public bool IsAdmin
        {
            get;
            set;
        }

        public int? AssignedIssuesCount
        {
            get;
            set;
        }

        public int? ReportedIssuesCount
        {
            get;
            set;
        }

        public string Token
        {
            get;
            set;
        }



        public string FullName => FirstName + " " + SurName;

        public string ProfileImage
        {
            get;
            set;
        }

        public string Designation
        {
            get;
            set;
        }

        public DateTime JoiningDate
        {
            get;
            set;
        }

        public string Branch
        {
            get; set;
        }

        public string Reporting
        {
            get;
            set;
        }

        public int? TeamLeadRole
        {
            get;
            set;
        }

        public string UserStory
        {
            get;
            set;
        }

        public string RegisteredDateTime
        {
            get;
            set;
        }

        public string LastConnection
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please Enter Mobile Number")]
        public string MobileNo
        {
            get;
            set;
        }

        public int EmployeeIndex
        {
            get;
            set;
        }

        public int GrpIndex
        {
            get;
            set;
        }

        public bool IsTeamLead
        {
            get;
            set;
        }

        public List<UserProjects> UserProjects
        {
            get;
            set;
        }

        public List<Issues> AssignedIssues
        {
            get;
            set;
        }

        public Guid CompanyId
        {
            get;
            set;
        }

        public List<Issues> ReportedIssues
        {
            get;
            set;
        }

        public List<MembersModel> Members
        {
            get;
            set;
        }

        public Guid CompanyGuid { get; set; }

        public int UnreadMessagesCount { get; set; }
        public string CompaniesListXml { get; set; }
        public List<CompaniesList> CompaniesList { get; set; }
        public bool IsAddedToChannel
        {
            get;
            set;
        }

        public bool IsDemoDataCleared { get; set; }

        public bool IsToShowDeleteIcon { get; set; }

        public string CompanyName { get; set; }

        public string CompanyMainLogo { get; set; }
        public string CompanyMiniLogo { get; set; }

        public Guid? EmployeeId { get; set; }
    }

    public class UserProjects
    {
        public Guid? ProjectId
        {
            get;
            set;
        }

        public string ProjectName
        {
            get;
            set;
        }

        public string GoalName
        {
            get;
            set;
        }

        public string RoleName
        {
            get;
            set;
        }
        public string UserName
        {
            get;
            set;
        }
    }

    public class CompaniesList
    {
        public string CompanyName { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? UserId { get; set; }
        public string RoleIds { get; set; }
        public string AuthToken { get; set; }
        public string SiteAddress { get; set; }
        public string CompanyMiniLogo { get; set; }
    }
    public class Issues
    {
        public Guid? UserStoryId
        {
            get;
            set;
        }

        public string UserStoryName
        {
            get;
            set;
        }

        public string EstimatedTime
        {
            get;
            set;
        }

        public string ReplannedDate
        {
            get;
            set;
        }

        public string Owner
        {
            get;
            set;
        }

        public Guid? OwnerId
        {
            get;
            set;
        }

        public string OwnerImage
        {
            get;
            set;
        }

        public string Dependency
        {
            get;
            set;
        }

        public Guid? DependencyId
        {
            get;
            set;
        }

        public string DependencyImage
        {
            get;
            set;
        }
    }

    public class MembersModel
    {
        public Guid? UserId
        {
            get;
            set;
        }

        public string UserName
        {
            get;
            set;
        }
    }

}
