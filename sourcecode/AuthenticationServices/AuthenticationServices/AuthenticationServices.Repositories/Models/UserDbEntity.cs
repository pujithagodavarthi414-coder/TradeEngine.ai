using System;

namespace AuthenticationServices.Repositories.Models
{
    public class UserDbEntity
    {
        /// <summary>
        /// Gets or sets the Id value.
        /// </summary>
        public Guid Id
        { get; set; }

        /// <summary>
        /// Gets or sets the CompanyId value.
        /// </summary>
        public Guid CompanyId
        { get; set; }

        /// <summary>
        /// Gets or sets the SurName value.
        /// </summary>
        public string SurName
        { get; set; }

        /// <summary>
        /// Gets or sets the FirstName value.
        /// </summary>
        public string FirstName
        { get; set; }

        /// <summary>
        /// Gets or sets the UserName value.
        /// </summary>
        public string UserName
        { get; set; }

        /// <summary>
        /// Gets or sets the Password value.
        /// </summary>
        public string Password
        { get; set; }

        /// <summary>
        /// Gets or sets the RoleId value.
        /// </summary>
        public Guid RoleId
        { get; set; }

        /// <summary>
        /// Gets or sets the IsPasswordForceReset value.
        /// </summary>
        public bool? IsPasswordForceReset
        { get; set; }

        /// <summary>
        /// Gets or sets the IsActive value.
        /// </summary>
        public bool IsActive
        { get; set; }

        /// <summary>
        /// Gets or sets the TimeZoneId value.
        /// </summary>
        public Guid? TimeZoneId
        { get; set; }

        /// <summary>
        /// Gets or sets the MobileNo value.
        /// </summary>
        public string MobileNo
        { get; set; }

        /// <summary>
        /// Gets or sets the IsAdmin value.
        /// </summary>
        public bool? IsAdmin
        { get; set; }

        /// <summary>
        /// Gets or sets the IsActiveOnMobile value.
        /// </summary>
        public bool IsActiveOnMobile
        { get; set; }

        /// <summary>
        /// Gets or sets the ProfileImage value.
        /// </summary>
        public string ProfileImage
        { get; set; }

        /// <summary>
        /// Gets or sets the RegisteredDateTime value.
        /// </summary>
        public DateTime RegisteredDateTime
        { get; set; }

        /// <summary>
        /// Gets or sets the LastConnection value.
        /// </summary>
        public DateTime? LastConnection
        { get; set; }

        /// <summary>
        /// Gets or sets the CreatedDateTime value.
        /// </summary>
        public DateTime CreatedDateTime
        { get; set; }

        /// <summary>
        /// Gets or sets the CreatedByUserId value.
        /// </summary>
        public Guid CreatedByUserId
        { get; set; }

        /// <summary>
        /// Gets or sets the UpdatedDateTime value.
        /// </summary>
        public DateTime? UpdatedDateTime
        { get; set; }

        /// <summary>
        /// Gets or sets the UpdatedByUserId value.
        /// </summary>
        public Guid? UpdatedByUserId
        { get; set; }

        /// <summary>
        /// Gets or sets the OriginalId value.
        /// </summary>
        public Guid OriginalId
        { get; set; }

        /// <summary>
        /// Sets the FullName value.
        /// </summary>
        public string FullName => FirstName + " " + SurName;

        /// <summary>
        /// Gets or sets the IsActive value.
        /// </summary>
        public bool IsExternal { get; set; }
        public string ClientId { get; set; }
        public string Scope { get; set; }
    }
}
