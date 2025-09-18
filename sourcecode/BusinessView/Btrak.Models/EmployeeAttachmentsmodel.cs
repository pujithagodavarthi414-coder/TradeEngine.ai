using System;

namespace Btrak.Models
{
   public  class EmployeeAttachmentsmodel
    {
        public string FileName
        {
            get;
            set;
        }

        public string Comment
        {
            get;
            set;
        }
        public Guid Id
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        public string FileAddedBy
        {
            get;
            set;
        }
        public DateTime AttachmentCreatedDate
        {
            get;
            set;
        }
        public decimal FileSize
        {
            get;
            set;
        }

        public string FileType
        {
            get;
            set;
        }
        public string PhotoGraph
        {
            get;
            set;
        }
        public Guid CreatedByUserId
        {
            get;
            set;
        }
        public Guid UpdatedByUserId
        {
            get;
            set;
        }
        public DateTime? UpdatedDateTime
        {
            get;
            set;
        }
    }
}
