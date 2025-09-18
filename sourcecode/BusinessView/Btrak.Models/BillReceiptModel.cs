using System;

namespace Btrak.Models
{
    public class BillReceiptModel
    {
       
            /// <summary>
            /// Gets or sets the Id value.
            /// </summary>
            public Guid Id
            { get; set; }

            /// <summary>
            /// Gets or sets the ReceiptImage value.
            /// </summary>
            public string ReceiptImage
            { get; set; }
        

            /// <summary>
            /// Gets or sets the ReceiptName value.
            /// </summary>
            public string ReceiptName
            { get; set; }
        public bool? ClaimReimbursement
        { get; set; }
        public Guid? ExpenseId
        { get; set; }

        /// <summary>
        /// Gets or sets the ReportId value.
        /// </summary>
        public Guid? ReportId
        { get; set; }

        /// <summary>
        /// Gets or sets the CreatedByUserId value.
        /// </summary>
        public Guid CreatedByUserId
        { get; set; }

        /// <summary>
        /// Gets or sets the CreatedDateTime value.
        /// </summary>
        public DateTime CreatedDateTime
        { get; set; }

        /// <summary>
        /// Gets or sets the UpdatedByUserId value.
        /// </summary>
        public Guid? UpdatedByUserId
        { get; set; }

        /// <summary>
        /// Gets or sets the UpdatedDateTime value.
        /// </summary>
        public DateTime? UpdatedDateTime
        { get; set; }
    }
}
