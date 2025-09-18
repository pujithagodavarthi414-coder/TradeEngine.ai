
using System;

namespace Btrak.Models
{
    public class FilesModel
    {
        public Guid? Id
        {
            get;
            set;
        }
        public Guid? UploadedFileId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string UploadedOn { get; set; }
        public string UploadedUserName { get; set; }
        public string UploadedUserProfilePhoto { get; set; }
        public Guid CreatedBy
        {
            get;
            set;
        }

        public DateTime CreatedOn
        {
            get;
            set;
        }

        public string FileId
        {
            get;
            set;
        }

        public string FileName
        {
            get;
            set;
        }

        public string FilePath
        {
            get;
            set;
        }

        public Guid? UserStoryId
        {
            get;
            set;
        }

        public Guid? LeadId
        {
            get;
            set;
        }

        public bool? IsTimeSheetUpload
        {
            get;
            set;
        }

        public Guid GoalId { get; set; }
        public Guid BoardTypeId { get; set; }
    }
}
