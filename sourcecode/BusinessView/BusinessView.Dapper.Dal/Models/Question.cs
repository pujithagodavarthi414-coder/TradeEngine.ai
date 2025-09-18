using System;

namespace Btrak.Dapper.Dal.Models
{
	public class QuestionDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CategoryId value.
		/// </summary>
		public Guid CategoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Question value.
		/// </summary>
		public string Question
		{ get; set; }

		/// <summary>
		/// Gets or sets the Option1 value.
		/// </summary>
		public string Option1
		{ get; set; }

		/// <summary>
		/// Gets or sets the Option2 value.
		/// </summary>
		public string Option2
		{ get; set; }

		/// <summary>
		/// Gets or sets the Option3 value.
		/// </summary>
		public string Option3
		{ get; set; }

		/// <summary>
		/// Gets or sets the Option4 value.
		/// </summary>
		public string Option4
		{ get; set; }

		/// <summary>
		/// Gets or sets the OptionNo value.
		/// </summary>
		public int? OptionNo
		{ get; set; }

		/// <summary>
		/// Gets or sets the MarksAllocated value.
		/// </summary>
		public Double MarksAllocated
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid? CreatedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime? CreatedDateTime
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
