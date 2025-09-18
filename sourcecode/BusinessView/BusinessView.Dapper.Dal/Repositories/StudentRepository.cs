using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StudentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Student table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StudentDbEntity aStudent)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStudent.Id);
					 vParams.Add("@Name",aStudent.Name);
					 vParams.Add("@RollNo",aStudent.RollNo);
					 vParams.Add("@EmailId",aStudent.EmailId);
					 vParams.Add("@Password",aStudent.Password);
					 vParams.Add("@MobileNo",aStudent.MobileNo);
					 vParams.Add("@City",aStudent.City);
					 vParams.Add("@CoutryId",aStudent.CoutryId);
					 vParams.Add("@StateId",aStudent.StateId);
					 vParams.Add("@DateOfBirth",aStudent.DateOfBirth);
					 vParams.Add("@GenderId",aStudent.GenderId);
					 vParams.Add("@Address",aStudent.Address);
					 vParams.Add("@CollegeId",aStudent.CollegeId);
					 vParams.Add("@StreamId",aStudent.StreamId);
					 vParams.Add("@BtechPercentage",aStudent.BtechPercentage);
					 vParams.Add("@InterPercentage",aStudent.InterPercentage);
					 vParams.Add("@TenthPercentage",aStudent.TenthPercentage);
					 vParams.Add("@YearOfCompletion",aStudent.YearOfCompletion);
					 vParams.Add("@ProfileImage",aStudent.ProfileImage);
					 vParams.Add("@ResumePath",aStudent.ResumePath);
					 vParams.Add("@CreatedDateTime",aStudent.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStudent.CreatedByUserId);
					 vParams.Add("@UpadatedDateTime",aStudent.UpadatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStudent.UpdatedByUserId);
					 vParams.Add("@FinalMarks",aStudent.FinalMarks);
					 int iResult = vConn.Execute("USP_StudentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Student table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StudentDbEntity aStudent)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStudent.Id);
					 vParams.Add("@Name",aStudent.Name);
					 vParams.Add("@RollNo",aStudent.RollNo);
					 vParams.Add("@EmailId",aStudent.EmailId);
					 vParams.Add("@Password",aStudent.Password);
					 vParams.Add("@MobileNo",aStudent.MobileNo);
					 vParams.Add("@City",aStudent.City);
					 vParams.Add("@CoutryId",aStudent.CoutryId);
					 vParams.Add("@StateId",aStudent.StateId);
					 vParams.Add("@DateOfBirth",aStudent.DateOfBirth);
					 vParams.Add("@GenderId",aStudent.GenderId);
					 vParams.Add("@Address",aStudent.Address);
					 vParams.Add("@CollegeId",aStudent.CollegeId);
					 vParams.Add("@StreamId",aStudent.StreamId);
					 vParams.Add("@BtechPercentage",aStudent.BtechPercentage);
					 vParams.Add("@InterPercentage",aStudent.InterPercentage);
					 vParams.Add("@TenthPercentage",aStudent.TenthPercentage);
					 vParams.Add("@YearOfCompletion",aStudent.YearOfCompletion);
					 vParams.Add("@ProfileImage",aStudent.ProfileImage);
					 vParams.Add("@ResumePath",aStudent.ResumePath);
					 vParams.Add("@CreatedDateTime",aStudent.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStudent.CreatedByUserId);
					 vParams.Add("@UpadatedDateTime",aStudent.UpadatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStudent.UpdatedByUserId);
					 vParams.Add("@FinalMarks",aStudent.FinalMarks);
					 int iResult = vConn.Execute("USP_StudentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Student table.
		/// </summary>
		public StudentDbEntity GetStudent(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StudentDbEntity>("USP_StudentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Student table.
		/// </summary>
		 public IEnumerable<StudentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StudentDbEntity>("USP_StudentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
