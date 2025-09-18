using System;

namespace Btrak.Dapper.Dal.Models
{
	public class StudentDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the Name value.
		/// </summary>
		public string Name
		{ get; set; }

		/// <summary>
		/// Gets or sets the RollNo value.
		/// </summary>
		public string RollNo
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmailId value.
		/// </summary>
		public string EmailId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Password value.
		/// </summary>
		public string Password
		{ get; set; }

		/// <summary>
		/// Gets or sets the MobileNo value.
		/// </summary>
		public string MobileNo
		{ get; set; }

		/// <summary>
		/// Gets or sets the City value.
		/// </summary>
		public string City
		{ get; set; }

		/// <summary>
		/// Gets or sets the CoutryId value.
		/// </summary>
		public Guid CoutryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StateId value.
		/// </summary>
		public Guid StateId
		{ get; set; }

		/// <summary>
		/// Gets or sets the DateOfBirth value.
		/// </summary>
		public DateTime DateOfBirth
		{ get; set; }

		/// <summary>
		/// Gets or sets the GenderId value.
		/// </summary>
		public Guid GenderId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Address value.
		/// </summary>
		public string Address
		{ get; set; }

		/// <summary>
		/// Gets or sets the CollegeId value.
		/// </summary>
		public Guid CollegeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StreamId value.
		/// </summary>
		public Guid StreamId
		{ get; set; }

		/// <summary>
		/// Gets or sets the BtechPercentage value.
		/// </summary>
		public Double BtechPercentage
		{ get; set; }

		/// <summary>
		/// Gets or sets the InterPercentage value.
		/// </summary>
		public Double InterPercentage
		{ get; set; }

		/// <summary>
		/// Gets or sets the TenthPercentage value.
		/// </summary>
		public Double TenthPercentage
		{ get; set; }

		/// <summary>
		/// Gets or sets the YearOfCompletion value.
		/// </summary>
		public DateTime YearOfCompletion
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProfileImage value.
		/// </summary>
		public string ProfileImage
		{ get; set; }

		/// <summary>
		/// Gets or sets the ResumePath value.
		/// </summary>
		public string ResumePath
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
		/// Gets or sets the UpadatedDateTime value.
		/// </summary>
		public DateTime? UpadatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedByUserId value.
		/// </summary>
		public Guid? UpdatedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FinalMarks value.
		/// </summary>
		public Double? FinalMarks
		{ get; set; }

	}
}
