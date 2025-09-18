using System;

namespace Btrak.Models
{
   public class ExpenseCommentModal
    {
        /// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
        { get; set; }

        /// <summary>
        /// Gets or sets the Comment value.
        /// </summary>
        public string Comment
        { get; set; }

        /// <summary>
        /// Gets or sets the CreatedByUserId value.
        /// </summary>
        public Guid CreatedByUserId
        { get; set; }

        public string CreatedByUserName
        { get; set; }
        /// <summary>
        /// Gets or sets the CreatedDateTime value.
        /// </summary>
       
        public DateTime CreatedDateTime
        { get; set; }

        /// <summary>
        /// Gets or sets the ExpenseId value.
        /// </summary>
        public Guid ExpenseId
        { get; set; }
        /// <summary>
        /// Gets or sets the ProfileImage value.
        /// </summary>
        public string ProfileImage
        { get; set; }
    }
}
