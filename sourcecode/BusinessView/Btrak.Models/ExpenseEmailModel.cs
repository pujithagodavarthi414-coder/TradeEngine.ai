using Postal;
using System;

namespace Btrak.Models
{
    public class ExpenseEmailModel :Postal.Email
    {
        public ExpenseEmailModel(string viewName) : base(viewName)
        {

        }
        public string FromName
        {
            get;
            set;
        }

        public string To
        {
            get;
            set;
        }
        public string FirstName
        {
            get;
            set;
        }
        public string CommentedUser
        {
            get;
            set;
        }
        
        public string ToName
        {
            get;
            set;
        }

        public string Cc
        {
            get;
            set;
        }
        public string SubmittedUsername
        { get; set; }

        /// <summary>
        /// Gets or sets the SubmittedByUserId value.
        /// </summary>
        public Guid? SubmittedByUserId
        { get; set; }

        public string ReportTitle
        { get; set; }

        public Guid ReportId
        { get; set; }

        public string Subject
        {
            get;
            set;
        }

        public string MessageBody
        {
            get;
            set;
        }
        public string ReasonForApprovalOrRejection
        { get; set; }
        public DateTime ReimbursedDateTime
        { get; set; }
        public string ExpenseComment
        { get; set; }
    }
}
