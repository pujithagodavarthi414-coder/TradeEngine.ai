using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ExamDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the StudentId value.
		/// </summary>
		public Guid StudentId
		{ get; set; }

		/// <summary>
		/// Gets or sets the QuestionNo value.
		/// </summary>
		public int QuestionNo
		{ get; set; }

		/// <summary>
		/// Gets or sets the QuestionId value.
		/// </summary>
		public Guid QuestionId
		{ get; set; }

		/// <summary>
		/// Gets or sets the OptionNo value.
		/// </summary>
		public int? OptionNo
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime? CreatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid? CreatedByUserId
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

	}
}
