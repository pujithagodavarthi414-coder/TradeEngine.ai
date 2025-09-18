using System;

namespace Btrak.Models.HrDashboard
{
    public class SignatureModel
    {
        public Guid? SignatureId { get; set; }
        public Guid? ReferenceId { get; set; }
        public string SignatureUrl { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string InvitedByName { get; set; }
        public string InvitedByImage { get; set; }
        public DateTime? CreatedOnDateTime { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? InviteeId { get; set; }
        public string InviteeName { get; set; }
        public string InviteeImage { get; set; }
        public string InviteeMail { get; set; }

        public string FileName { get; set; }
        public string FilePath { get; set; }
        public string FileExtension { get; set; }
    }
}
