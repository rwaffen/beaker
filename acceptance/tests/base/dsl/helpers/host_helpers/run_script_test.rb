require "helpers/test_helper"

test_name "dsl::helpers::host_helpers #run_script" do
  step "#run_script fails when the local script cannot be found" do
    assert_raises IOError do
      run_script "/non/existent/testfile.sh"
    end
  end

  step "#run_script fails when there is an error running the remote script" do
    Dir.mktmpdir do |local_dir|
      local_filename, _contents = create_local_file_from_fixture("failing_shell_script", local_dir, "testfile.sh", "a+x")

      assert_raises Beaker::Host::CommandFailure do
        run_script local_filename
      end
    end
  end

  step "#run_script passes along options when running the remote command" do
    Dir.mktmpdir do |local_dir|
      local_filename, _contents = create_local_file_from_fixture("failing_shell_script", local_dir, "testfile.sh", "a+x")

      result = run_script local_filename, { :accept_all_exit_codes => true }
      assert_equal 1, result.exit_code
    end
  end

  step "#run_script runs the script on the remote host" do
    Dir.mktmpdir do |local_dir|
      local_filename, _contents = create_local_file_from_fixture("shell_script_with_output", local_dir, "testfile.sh", "a+x")

      results = run_script local_filename
      assert_equal 0, results.exit_code
      assert_equal "output\n", results.stdout
    end
  end

  step "#run_script allows assertions in an optional block" do
    Dir.mktmpdir do |local_dir|
      local_filename, _contents = create_local_file_from_fixture("shell_script_with_output", local_dir, "testfile.sh", "a+x")

      run_script local_filename do |result|
        assert_equal 0, result.exit_code
        assert_equal "output\n", result.stdout
      end
    end
  end
end
