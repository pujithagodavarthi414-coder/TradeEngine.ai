using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PolicyReviewTool
{
    public class CreateNewPolicyModel
    {
        public Guid Id { get; set; }

        public string RefId { get; set; }

        public string Description { get; set; }

        public string PdfFileBlobPath { get; set; }

        public string WordFileBlobPath { get; set; }

        public DateTime ReviewDate { get; set; }

        public Guid CategoryId { get; set; }

        public bool MustRead { get; set; }

        public Guid PolicyId { get; set; }

        public bool HasRead { get; set; }

        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        public Guid UserId { get; set; }

        public DateTime OpenedDate { get; set; }

        public DateTime ReadDate { get; set; }

        public DateTime InsertedDate { get; set; }

        public DateTime DeletedDate { get; set; }

        public DateTime UpdatedDate { get; set; }

        public DateTime PrintedDate { get; set; }

        public DateTime DownloadedDate { get; set; }

        public DateTime ImportedDate { get; set; }

        public DateTime ExportedDate { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public Guid CreatedByUserId { get; set; }

        public DateTime UpdatedDateTime { get; set; }

        public Guid UpdatedByUserId { get; set; }

    }
}
