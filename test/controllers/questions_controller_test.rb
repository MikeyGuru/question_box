require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  def valid_question_data
    { question: { title: "How do I #{Faker::Hacker.verb} #{Faker::Hacker.noun}?",
                  text: Faker::Lorem.paragraph } }
  end

  def invalid_question_data
    { question: { title: "",
                  text: "" } }
  end

  context "GET questions#home" do
    setup { get :home }

    should render_template("home")
    should respond_with(:success)

    should "instantiate a question object" do
      assert assigns[:question], "Should have a question"
    end

    should "load most recent questions" do
      assert assigns[:recent_questions], "Should load recent questions"
    end
  end

  context "GET questions#index" do
    setup { get :index }

    should render_template("index")
    should respond_with(:success)

    should "load questions" do
      assert assigns[:questions], "Should load questions"
    end
  end

  context "GET questions#new" do
    context "when not logged in" do
      setup { get :new }

      should "redirect to login" do
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        get :new, {}, logged_in_session
      end

      should render_template("new")
      should respond_with(:success)

      should "instantiate a question object" do
        assert assigns[:question], "Should have a question"
      end
    end
  end

  context "POST questions#create" do
    context "when not logged in" do
      setup { post :create }

      should "redirect to login" do
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      context "with invalid data" do
        setup do
          post :create, invalid_question_data, logged_in_session
        end

        should render_template(:new)

        should "instantiate an invalid question object" do
          assert_invalid_model(:question)
        end
      end

      context "with valid data" do
        setup do
          post :create, valid_question_data, logged_in_session
        end

        should "create a question" do
          assert_saved_model(:question)
        end

        should "redirect to index" do
          assert_redirected_to question_path(assigns[:question])
        end
      end
    end
  end
end
