class SeedService
  class << self
    def essentials
      TeachingRange.seed
      MasteryLevel.seed
      Subject.seed
      Involvement.seed
      Skill.seed
      Context.seed
      CollectionTag.seed
      Standard.seed
    end

    # def l_tags
    #   self.essentials
    #   Subject.new(name:"Technology").save!
    # end
    def admin
      self.essentials
      user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.name = "SCOPES-df Team"
        user.bio = "SCOPES team bio should be here"
        user.user!
      end
      self.place()
      user.addOrg(Organization.first, false)
      user.save!
      user
    end

    def user
      user = User.find_or_create_by!(email: "otherUser@gmail.com") do |user|
        user.name = "Lucas Lorenzo Pena"
        user.password = "somepassword"
        user.password_confirmation = "somepassword"
        user.user!
      end
      user.setInvolvements(["classroom teacher"])
    end

    def place
      place = Organization.find_or_create_by!(name: "Fab Foundation") do |x|
        x.name = "Fab Foundation"
        x.desc = "Formed in 2009 to facilitate and support the growth of the international fab lab network as well as the development of regional capacity-building organizations. The Fab Foundation is a US non-profit 501(c) 3 organization that emerged from MIT’s Center for Bits & Atoms Fab Lab Program. Our mission is to provide access to the tools, the knowledge and the financial means to educate, innovate and invent using technology and digital fabrication to allow anyone to make (almost) anything, and thereby creating opportunities to improve lives and livelihoods around the world. Community organizations, educational institutions and non-profit concerns are our primary beneficiaries.
The Foundation’s programs focus on: education (.edu), organizational capacity building and services (.org), and business opportunity (.com)."
        x.address_line1 = "Milk Street"
        x.address_line2 = "50"
        x.locality = "Boston"
        x.post_code = "02109"
        x.country = "USA"
      end
      place.setPoints(-71.057521, 42.356978)
      place.validated!
    end

    def lesson
      lesson = Lesson.find_or_create_by!(name: "Robot Arm") do |x|
        x.name = "Robot Arm"
        # x.topline = "Here is topline"
        # x.summary = "Here is summary"
        # x.learning_objectives = {}
        # x.description = "Here is description"
        # x.assessment_criteria = "Here is criteria"
        # x.further_readings = {}
        # x.difficulty_level = 1
        # x.outcome_links = {}
        ## x.original_lesson = nil
      end
    end

    def lesson_service
      lesson =
          {
              # TAB 1 - Overviewr
              # Basic Information
              name: "Name here",
              topline: "Here is topline",
              summary: "Here is summary",

              # Authors
              other_users_emails:
                  ["user2@example.com"], #will call create user <<
              associated_places_ids:
                  [Organization.first.id],

              # Objectives
              learning_objectives:
                  ["Learn how to build something", "Learn how to build this other thing"],

              # Lesson Ambitions
              description: "Here is description",
              assessment_criteria: "Here is criteria",
              # assessment_criteria_files get set on another form!!

              further_readings:
                  ["https://www.youtube.com/watch?v=P2r9U4wkjcc", "http://mit.org"],


              # TAB 2 - Standards

              standards:
                  [{
                       name: "standard name is here",
                       descriptions: ["some description here", "and another here"]
                   },
                   {
                       name: "other standard",
                       descriptions: ["other standard desc", "yet another for other standard"]
                   }],

              # Tab 3 - Details
              grade_range: {start: 0, end: 12},
              subjects:
                  ["technology", "science"],
              mastery_level:
                  {student: "1", educator: "2"},
              skills: [
                  {name: "CNC", level: "4"},
                  {name: "Welding", level: "3"}
              ],
              context:
                  ["In Classroom", "Outdoors"],
              collection_tag: "fab certified/tested",
              tags:
                  ["Pinball"]
          }

      LessonService.find_or_create_and_update(nil, lesson, User.first)

    end

    def step
      step = Step.new(name: "Assemble Materials")
      # x.topline = "Here is topline"
      # x.summary = "Here is summary"
      # x.learning_objectives = {}
      # x.description = "Here is description"
      # x.assessment_criteria = "Here is criteria"
      # x.further_readings = {}
      # x.difficulty_level = 1
      # x.outcome_links = {}
      ## x.original_lesson = nil
      #step_number: 1
      Lesson.first.steps << step
    end

    def step_service
      step = {
          summary: "Step Subject Here",
          duration: "1508",
          description: "description of my step here",
          # supporting_files  >> has its own endpoint
          materials: [
              {number: "4", name: "Computers"},
              {number: "35", name: "Beakers"}
          ],
          tools:
              ["3D Printer"],
          external_links:
              ["https://api.jquery.com/category/manipulation/dom-removal/"],
          # supporting_material >> has own endpoint
      }
      Step.find_or_create_and_update(nil, Lesson.first.id, step, User.first)
    end

    def lantern_seeder

      lesson =
          {
              name: "Laser Cut Lantern - Hong Kong",
              topline: "Light up history and art exploration combining modern day lasercut interpretations of traditional Chinese lanterns and recycled materials",
              description: "Ethnic Chinese celebrate the harvest worldwide during the Mid-Autumn Festival.  It is synonymous with mooncakes (traditional pastry) and lighting paper lanterns. This lesson will introduce students, from all backgrounds, to this tradition. Rather than purchasing mass-produced plastic lanterns, the lesson will introduce students to the traditional roots of handmade lanterns by teaching them how to make a digital fabricated version using lasers (cutters). Students will add their own personal and creative interpretations. At the same time, the lesson will emphasize sustainability values by using recycled materials for the creations. Our methodology can actually be used to design lanterns for other festivals, like Halloween; or other practical uses, like table lamps.",


              learning_objectives:
                  ["Students will learn about the traditions and values of the Chinese Mid-Autumn Festival.", " Students will learn that holidays reflect different backgrounds, legends, and/or traditions. In this lesson, students will demonstrate their ability to compare and contrast different versions of the Legend of Chang E.", "Students will re-imagine and re-appropriate design traditions into their own Mid-Autumn Festival lantern.", "Students will learn the basics of vector drawing (for this lesson, we will use Inkscape software).", "Students will learn the value of sustainability and upcycling by using recycled cardboard materials for their lanterns.", "Students will learn the basics of laser cutting their own lanterns.", "Students will learn the basics of electronics and light their own lanterns with LEDs.", "Students will gain technical skills by hands-on learning.  Experiences will include making and assembling their own lanterns and using a variety of tools (e.g. hot glue gun).", "Students will recognize that legends are a way of explaining our perception of the world in which we live."],

              assessment_criteria: "Students will be graded upon construction of their lanterns. Criteria may include:
Did students follow directions correctly?
Did students create a design on their lanterns related to the Mid-Autumn Festival?
Did students use Fab techniques properly?
Did students clean up work spaces completely?
Did students work well with classmates?
",

              steps: [{
                          summary: "Explore and Compare Two Chang E Legends",
                          duration: "3600",
                          description: "Review Mid-Autumn Festival “Hong-Kong Mid-Autumn Festival
http://www.hongkongextras.com/_mid_autumn_festival.html

Review the Legend of Chang E
http://www.moonfestival.org/the-legend-of-chang-e.html

Review the two Versions of Legend of Chang E (Version 2 starts at the 6:10 mark)
https://www.youtube.com/watch?v=_tTiVekamYk

Students will prepare the main box for the lantern. If materials do not match the materials required for the template, students will use a boxmaker utility (e.g. makercase.com) to generate work plans for material.

Essential Question: Do you know any other stories from other cultures about the sun?

Explain that there are several versions of Legend of Chang E,
Play  two different versions of the Legend of Chang E for the class  https://www.youtube.com/watch?v=_tTiVekamYk
Instruct students to take a closer look at main characters in Legend of Chang E by taking characterization notes:

What do the main characters look like?
What do the main characters do?
What do the main character say?
What do others say about them?


4. Have students share and compare their visualizations in small groups, discussing each character's internal and external conflicts.

5. Introduce the concept of “compare and contrast” by explaining how the technique is used to identify similarities and differences.

6. Comparison and Synthesis of Ideas (CSI).

After closely analyzing the two versions of Legend of Chang E, students will compare and contrast ideas from each.  They should be sure to list the specific words each version used. This strategy can also be used to help students recognize the thematic content that is common to both versions. Students should be able to generate both differences and similarities, as well as synthesize the information that each version shares.

7. Expository Writing Prompt:

Have students work with partners to write an expository paragraph that compares or contrasts the two versions and details about Hou Yi and Chang E. Include examples from different types of characterization, appearance, actions, words, and the reactions of others. Make sure students use:
Topic sentence
Supporting details and commentary
Transition words
Present tense verbs
Correct shifts in pronouns

Formative Assessment: Examine students’ paragraphs to determine their levels of understanding.  Check for structure, topic sentences, transitions, supporting details, and general commentary.

TEACHER NOTE: Teachers could use guided writing to support students in the writing process. They could co-construct a “compare” paragraph --- as a whole class or in small groups ---  and then have students write  “contrast” paragraphs independently.

8. Closure:

Students will summarize what they have learned. A group discussion or questions-and-answers written on the board will reinforce knowledge. Students can compare and contrast Mid-Autumn Festival traditions with their own holidays.
",
                          materials: [
                              {number: "1 per student", name: "Notebooks"},
                          ],
                          tools:
                              ["3D Printer"],
                          external_links:
                              ["https://www.youtube.com/watch?v=_tTiVekamYk", "http://www.moonfestival.org/the-legend-of-chang-e.html", "http://www.hongkongextras.com/_mid_autumn_festival.html"],
                      }, {

                          #other step is here
                          summary: "Design & Build Your Own Laser Cut Lantern",
                          duration: "3600",
                          description: "1. Students design and draw the lantern.

2. Vectorizing the drawing.

First, the relevant drawing is now digitized by taking a digital photo of it.  Then upload the photo to a shared drive, where a computer with a vector graphics software like Inkscape and/or Adobe Illustrator can access it. For Inkscape:

Open the JPG of the lantern drawing in Inkscape
Use Trace Bitmap to strengthen the line drawing
Use “simplify” to simplify the line drawing
Save the drawing as a PDF
Upload the PDF to the shared drive

​​​Design Files:

 Lantern outlines.pdf - https://drive.google.com/file/d/0B3tPBZnliO7ba1NkUDA3TWtYVHc/view?usp=drive_web
​​
 Mooncake shaped lanterns.pdf - https://drive.google.com/file/d/0B3tPBZnliO7bOTdfbTBTdzFDMVk/view?usp=drive_web
​​
 Mid Autumn calligraphy and YMCM logo.pdf - https://drive.google.com/file/d/0B3tPBZnliO7bazJibTV4OHQxUVE/view?usp=drive_web
​

5. Laser-cutting the lantern drawing

Test and calibrate the laser cutter (eg, power, speed, align height and material)
Open the PDF with the laser cutter software (for this lesson, Corel)
Set the area size to that of the proposed shaped lanterns
Highlight drawing to the lasercut and align to the center, then cut

6. Assembling and lighting the lantern

The lanterns will be kept together by folds/flaps, where they should be hot glued together.
Students may continue to design the exterior of the cardboard lantern by eg, painting, pen or colored drawings, stickers. Cellophane can also be added on the interior, if which LEDs are used to give different light effects. These can also be laser-cut engravings on the lantern.
Before sealing the entire lantern in, students should affix the coin battery and choice of color of LED in the desired location. Some students will do more than one LED in different colors for different light effects showing their drawings. Students should affix the LEDs using clear tape for short-term use, and glue for longer term use. Switches can be added for further functionality and longer term use.
the hook is where the MDF handle can be used to hoist the lantern in a horizontal position for your night out!
",
                          materials: [
                              {number: "Approximately 5 per student", name: "LED"},
                              {number: "1 per student", name: "Sheet of recycled cardboard for laser cutting"},
                              {number: "1 per student", name: "Optional decorative materials (e.g. colored cellophane, buttons, glitter, etc.)"},
                              {number: "1 per student", name: "Coin battery"},
                          ],
                          tools:
                              ["Laser Cutter", "Hot Glue Gun", "Digital Camera", "Computers with 2D Vector Graphic Software"],
                          external_links:
                              ["https://api.jquery.com/category/manipulation/dom-removal/"],
                      }],
              standards: [{
                              name: "Common Core Social Studies Unifying Theme: Development, Movement, and Interaction of Cultures",
                              descriptions: ["Role of diversity within and among cultures", "Role of cultural beliefs and values (i.e. such as belief systems, religious faith, or political ideals) in affecting institutions, literature, music, and/or art.", "Effect of ongoing cultural diffusion and change on different ideas and beliefs."]
                          },
                          {
                              name: "Common Core Social Studies Unifying Theme: Social Studies Thinking and Process Skills",
                              descriptions: ["Comparing and contrasting", "Identifying cause and effect", "Drawing inferences and making conclusions", "Evaluating", "Distinguishing fact vs. opinion."]
                          },
                          {
                              name: "Common Core Social Studies Unifying Theme: Sequencing and Chronology Skills ",
                              descriptions: ["Using the vocabulary of time and place", "Placing events in chronological order", "Sequencing events on a timeline", "Creating timelines", "Understanding concepts of time, continuity, and change."]
                          },
                          {
                              name: "National Visual Arts Standards",
                              descriptions: ["NVA 1.4: Students use art materials and tools in a safe and responsible manner", "NVA 2.3: Students use visual structures and functions of art to communicate ideas", "NVA 3.2: Students select and use subject matter, symbols, and ideas to communicate meaning", "NVA 4.1: Students know that the visual arts have both a history and specific relationships to various cultures"]
                          },
                          {
                              name: "I Can Statements for Reading Anchor Standard 1",
                              descriptions: ["I can read closely to determine what the text says explicitly", "I can support logical inferences from the text when writing or speaking", "I can cite specific textual evidence to support conclusions"]
                          },
                          {
                              name: "I Can Statements for Reading Anchor Standard 6",
                              descriptions: ["I can assess how point of view shapes the content and style of a text", "I can assess how purpose shapes the content and style of a text"]
                          },
                          {
                              name: "I Can Statements for Reading Anchor Standard 8",
                              descriptions: ["I can delineate and evaluate specific claims", "I can delineate and evaluate the validity of the reasoning of the claim", "I can delineate and evaluate the sufficiency of the evidence for the reasoning"]
                          },
                          {
                              name: "I Can Statements for Reading Anchor Standard 9",
                              descriptions: ["I can analyze how two or more texts address similar themes or topics to build knowledge", "I can analyze how two or more texts address similar themes or topics to compare the authors’ approaches"]
                          },
                          {
                              name: "I Can Statements for Reading Anchor Standard 10",
                              descriptions: ["I can read and comprehend complex literary texts independently and proficiently", "I can read and comprehend complex informational texts independently and proficiently"]
                          },
                          {
                              name: "I Can Statements for Writing Anchor Standard 3",
                              descriptions: ["I can write a narrative paper", "I can develop a narrator and/or characters", "I can develop a plot", "I can use vocabulary and sensory language"]
                          },
                          {
                              name: "I Can Statements for Writing Anchor Standard 4",
                              descriptions: ["I can develop grade-level appropriate writing"]
                          },
                          {
                              name: "I Can Statements for Writing Anchor Standard 8",
                              descriptions: ["I can find information from print sources", "I can find information from digital sources", "I can decide if a source is credible"]
                          },
                          {
                              name: "I Can Statements for Writing Anchor Standard 9",
                              descriptions: ["I can use pieces from literary texts to support my writing", "I can use pieces from informational text to support my writing"]
                          },
                          {
                              name: "I Can Statements for Reading Anchor Standard 10",
                              descriptions: ["I can write routinely for many reasons, purposes, and audiences"]
                          },
                          {
                              name: "Digital Fabrication Competencies: I can statements",
                              descriptions: ["(FAB.1): The Design Process: I can use the digital fabrication design process and quality assurance principles to analyze and solve design problems. This includes journal writing to document progress and capture ideas during the development phase., purposes, and audiences", "(FAB.2): Sketching and Visualization: I can brainstorm, conceptualize and sketch design projects and components, by hand sketch. This includes paper prototyping", "(FAB.3): Create Models: I can create models to illustrate the design of project and components This include using and/or creating a file during the modeling process.", "(FAB.3): Create Models: I can create models to illustrate the design of project and components This include using and/or creating a file during the modeling process.", "(FAB.4): Interpret and prepare 2D and 3D drawings: I can create and interpret auxiliary views, orthographic projections, isometric drawing, oblique drawings and perspective drawings. I can also use 2D and 3D modeling software to document work and communicate solutions.", "(FAB.5): Computer-Aided Modeling: I can create models to illustrate the design of projects, including apply manufacturing processes (e.g. casting, molding, separating, assembling, finishing, and rapid prototyping).", "(FAB.7): Precision Digital Fabrication Machining: I can apply principles of precision machining to measuring work pieces, drawing interpretations, and inspect workpieces according to specifications.", "(FAB.8): Measurement and Interpretation: I can interpret drawings and documentation and perform measurements.", "(FAB.9): Layout and Planning: I can determine product requirements, dimensions, and tolerances from drawing and specifications.", "(FAB.10): Implement safety procedures. I can demonstrate knowledge of FAB Lab safety rules and guidelines."]
                          }],

              grade_range: {start: 5, end: 9},
              subjects: ["technology", "science", "engineering", "arts"],
              mastery_level: {student: "1", educator: "2"},
              skills: [
                  {name: "CAD Design", level: "1"},
                  {name: "Electrical", level: "1"}
              ],
              context: ["In Classroom", "In fablab"],
              collection_tag: "fab certified/tested"
          }; steps = lesson.delete(:steps)


    end

    def pinball
      lesson =
          {
              name: "Pinball Machine Lesson (Understanding Energy)",
              topline: "Build some unique energy for physics and math by designing simple and complex machines, in the form of an old school arcade pinball games",
              description: "A 9th grade class can learn conceptual physics as students explore digital fabrication tools to design a pinball machine.  When they laser cut their prototypes, students will gain an understanding of the applications of potential, kinetic and mechanical energy through simple and complex machines.",

              learning_objectives:
                  ["Design and build a pinball machine utilizing fab lab tools.", "Understand how elastic potential energy, levers, and force are used.", "Understand the concepts related to work and energy."],

              assessment_criteria: "Students’ knowledge, skills, and aptitudes will be assessed using selected response items and rubrics for class participation, group work, engineering problem solving, brief constructed responses, and extended constructed responses summarizing the lesson.

Pre-Test Practice Test (Chapter 9- with answers)
http://marsd.org/cms/lib7/NJ01000603/Centricity/Domain/266/CD%209.1%20Work%20and%20Energy%20Answers.pdf

Formative Assessment (Chapter 9-with answers)
https://d3jc3ahdjad7x7.cloudfront.net/YhXdaDN05u8IzfPKjlMqrJ7KQZJlSEgbGQLCfrwLSx3xNDo6.pdf

Post-Test (Repeat of Practice Test)
http://marsd.org/cms/lib7/NJ01000603/Centricity/Domain/266/CD%209.1%20Work%20and%20Energy%20Answers.pdf


Pinball Machine Student Project Rubric

The Pinball Machine student project rubrics will be presented in advance of the activities to familiarize students with the expectations and performance digital fabrication criteria. They will also be reviewed during the activities to guide students in the completion of assignments.

Design Specifications				27 pts (3pts each)
Sturdy sides to keep ball in field
Ball launcher mechanism
Buttons to activate the flipper are easily pressed
Flipper mechanism made of 4 layers of cardboard
Flipper mechanism easily pivots
Obstacles in playing field
Ball catcher
Ball does not get hung on playing field
Barriers that keep the ball from going behind flippers

Explanation	(must be neatly written on a separate sheet of paper)		24 pts (4pts each)
Explanation of how levers are used in your pinball game
Explanation of how elastic potential energy is used in your pinball game

Analysis
Measure distance between where the button attaches to the flipper and pivot: __________
Measure distance between where the marble hits the flipper and pivot: ______________
Find the force multiplier ratio (b divided by a):  ______________
Measure the angle of your playing field:  ______________

Documentation		28 pts (4pts each)
Original Sketch
Final Sketch Side view
Final Sketch Top view
Neatly drawn
Picture or Sketch of Flipper Prototype
Sketch of Ball Launcher Mechanism
Picture of Final Pinball Machine

Aesthetics				10 pts
Neat Construction
Interesting decorations

Other
Group evaluation			8 pts(uploaded to folder
Self Evaluation			3 pts

--------------------
Bonus Points for Theme		10 pts ",

              further_readings:
                  ["http://marsd.org/cms/lib7/NJ01000603/Centricity/Domain/266/CD%209.1%20Work%20and%20Energy%20Answers.pdf", "https://d3jc3ahdjad7x7.cloudfront.net/YhXdaDN05u8IzfPKjlMqrJ7KQZJlSEgbGQLCfrwLSx3xNDo6.pdf", "http://marsd.org/cms/lib7/NJ01000603/Centricity/Domain/266/CD%209.1%20Work%20and%20Energy%20Answers.pdf"],

              steps: [{
                          summary: "Introduction to the lesson",
                          duration: "600",
                          description: "Show students examples of pinball machines by showing the following videos:  https://www.youtube.com/watch?v=gnrrbKFWL3Q
https://www.youtube.com/watch?v=jqwOaPYjKXI (min 11:57-end)
After watching the video, discuss the motion of the flipper.  The flipper transfers energy to the ball to keep the ball in motion. Discuss with students how pinball machines are controlled with electronics so the energy transfer is electrical to mechanical.
Show that the transfer of energy in their cardboard pinball machine will be elastic to mechanical.
Point out that the travel of the ball is interrupted by bouncing off obstacles.  These obstacles make the play more interesting.
Show that there is a launcher mechanism off camera that causes the ball to launch into the playing field.  The launcher gives the ball the initial speed on the playing field.
Discuss the rubric for the activity.",

                          external_links:
                              ["https://www.youtube.com/watch?v=gnrrbKFWL3Q", "https://www.youtube.com/watch?v=jqwOaPYjKXI"],
                      }, {
                          summary: "PART A: Making the base",
                          duration: "3600",
                          description: "Cut a rectangle out of corrugated cardboard to the desired size.  This is usually 18-24 inches long and 13-16 inches wide.
Cut some long strips of cardboard to make the 4 sides.  These sides will keep the marble on the playing field.
Glue the strips around the perimeter of the board.
Add cardboard ramps, cardboard obstacles, or small toys around the board to create obstacles or rebound surfaces.  Students can also make their pinball machine themed with vinyl decals if time, materials and equipment permit.
Cut angled cardboard pieces to attach to the bottom of the base to provide an angle for the playing field.  A fast board has about 12-15 degree slope.  A slower board has about 5 degrees slope.
The included design files have all of the necessary components for an 16 inch x 10 inch base with a 10 degree slope and is capable of being made on an Epilog Mini 24”x12” laser cutter common in many Fab Labs. The file may have to be modified to work with your local equipment.


Teacher Led Discussion:  Gravitational potential energy depends on the height of an object above the ground.  In the pinball machine a larger angle results in a larger gravitational potential energy therefore larger kinetic energy.  Because KE = ½ mv2 higher kinetic energy translates to higher speed.",
                          materials: [{number: "1 per student", name: "Large sheet of recycled cardboard for laser cutting"}],
                          tools:
                              ["Laser Cutter", "Computers with 2D Vector Graphic Software"],
                          external_links:
                              ["https://api.jquery.com/category/manipulation/dom-removal/"],
                      }, {
                          summary: "PART B: Making the flippers",
                          duration: "1800",
                          description: "Teacher Led Discussion: A bell crank mechanism transfers horizontal motion to vertical motion.  Show student videos of bell crank mechanisms in motion.
https://www.youtube.com/watch?v=-nuAhMMAbXw,
https://www.youtube.com/watch?v=26D-_Fo0Tlk.
For the pinball machine, the short leg is attached to the push button from the side of the pinball machine.  This is the horizontal motion.  The long leg has vertical motion and bats the marble back onto the playing field.  Essentially a bell crank mechanism is two levers attached at a stationary point.

Basic Bell Crank

Make a single L-shaped flipper from cardboard.  This is a basic bell crank mechanism.  A good starting point is for the long part of the L to be 3 inches and the short part 2 inches.
Drill a stationary pivot hole in the corner of the single layer flipper.
Test the flipper shape, size, and placement of the pivot and push button points.  Your goal is to have a small horizontal motion, with a small force required and a fast vertical motion to give the ball more speed.
Once you have decided on your design, build two final flippers by gluing 4 layers of cardboard together.
Cover the front of the flipper with poster board to give the marble a good surface for bouncing. The included design file has the components for two sets of flippers and is capable of being made on an Epilog Mini 24”x12” laser cutter common in many Fab Labs. The file may have to be modified to work with your local equipment.",
                          materials: [
                              {number: "1 per student", name: "Remainder of Large sheet of recycled cardboard for laser cutting"},
                              {number: "1 per student", name: "Marble"},
                              {number: "1 per student", name: "Small piece of poster board"}
                          ],
                          tools:
                              ["Laser Cutter", "Computers with 2D Vector Graphic Software"],
                          external_links:
                              ["https://www.youtube.com/watch?v=-nuAhMMAbXw", "https://www.youtube.com/watch?v=26D-_Fo0Tlk."],
                      }, {

                          summary: "PART C: Make Push Buttons",
                          duration: "1800",
                          description: "Cut small rectangles about three inches above the bottom edge of the box.


Cut and glue long strips of cardboard to make the main part of the push button.  (See diagram below)

Make small squares off cardboard to glue on the end to make top of the push button.  This will be the part that the player will use to activate the mechanism.

Place the push buttons in the rectangular slots on the playing field (created in #1)",
                          materials: [


                              {number: "1 per student", name: "Glue"}],
                          tools:
                              ["Laser Cutter", "Computers with 2D Vector Graphic Software"],
                      }, {
                          summary: "PART D: Attaching the button to the flipper ",
                          duration: "300",
                          description: "Attach push button to the flipper in the location determined in Activity 2.  Use brads, bolts, or skewers that will allow the pushbutton and flipper to rotate.  You will need to come up with a design to effectively attach the buttons to the flippers. The basic design is shown below.


          2. Add rubber bands to flippers and buttons provide a return force.  Play with the arrangement of the rubber bands to find the best return force and smoothest flipper motion.

          Teacher Led Discussion:  The arrangement of the rubber bands is very important.  When the button is pressed the rubber bands should be stretched.  The work done in moving the button transfers energy to the rubber bands.  That energy is then released when the button is released and the rubber bands pull the flipper mechanism back to its original position.  Some of the energy is transferred to the marble on the playing field.

          3. Once you are satisfied with the arrangement of rubber bands, flipper, and buttons, permanently attach the flipper mechanism to the playing field with a bolt, skewer, or dowel through the stationary point.

          4. Glue cardboard strips to the playing field to provide guides for the push button.

              5. The included design files also incorporate push buttons.

                  6. Measure distance between where the button attaches to the flipper and stationary pivot: ________
                                                                            7.  Measure distance between where the marble hits the flipper and stationary pivot: _____________
                                                                            8. Find the IMA which is the ratio of the two distances (6 divided by 7):  ______________

                                                                            Teacher lead discussion:  In a lever system, the distances are used to find the Ideal Mechanical Advantage (IMA).   The equation for IMA is input distance/ output distance.  In most instances we want a larger than 1 IMA because we want to input a smaller force and get a larger output force.  However, for this application we sacrifice force in order to get a larger range of motion for our flipper.  Another example of sacrificing IMA to get a larger range in motion is the forearm of humans.",
                          materials: [
                              {number: "2 per student", name: "rubber bands"},
                              {number: "1 per student", name: "ruler"}],
                          tools:
                              ["Laser Cutter", "Computers with 2D Vector Graphic Software"]
                      }, {

                          summary: "PART E: Making a launcher ",
                          duration: "300",
                          description: "Teacher Led Discussion:  The most common launcher for a pinball machine is a spring system, as seen in the picture to the right1.  A spring system is very similar to a rubber band system because they both convert elastic potential energy to kinetic energy.  A spring system can be stretched or compressed to gain elastic potential energy; however, a rubber band system can only be stretched.  In the following directions, students will create a rubber band launcher.  In the rubber band launcher pulling the paddle does work on the launcher mechanism creating elastic potential energy.  When the system is triggered, the elastic potential energy is converted to kinetic energy putting the ball into motion.  Students can develop alternate ball launching mechanisms such as a gravity ramp launcher or spinner launcher.


                                                                                Fold out a file folder and roll it up to make a launching tube.

                                                                                Glue a circular cardboard piece, slightly smaller than the launching tube, to the end of a dowel rod, paint stirrer, large craft stick, pencil, or similar long cylinder.

                                                                                Place the plunger made in #2.  Attach a rubber band from the top of the file folder tube to the plunger.  To change the speed of marble launch, change the  type of rubber band and placement of the rubber band on the plunger.

                                                                            Attach the launcher to the side of the pinball board.

                                                                                Cut a square hole in the side of the top of the cardboard base.

                                                                                Attach a flat piece of cardboard and a curved piece of cardboard to carry the ball from the launcher to the playing field.",
                          materials: [

                              {number: "2 per student", name: "rubber bands"},
                              {number: "1 per student", name: "dowel rod or similar"}],
                          tools:
                              ["Laser Cutter", "Computers with 2D Vector Graphic Software", "Glue"],

                      }, {

                          summary: "PART F: Making a ball catcher ",
                          duration: "300",
                          description: "Cut a 3 inch long x 1 inch high slot in the bottom of the playing field for the ball catcher.

                                                                                Create a catcher box by gluing together a small rectangular box.

                                                                                    Attach the box below the 3 inch slot.

                                                                                As an extension activity, have the students design and laser cut their own box for a ball catcher.

                                                                                Activity 7: Placing obstacles on the playing field/decorating the pinball machine
                                                                            Choose objects to place on the playing field to make obstacles for the marble as it travels on the playing field.
                                                                                Carefully decide on the layout; make sure that the marble will not get stuck on an obstacle.
                                                                                Use hot glue to attach obstacles.
                                                                                    Paint or decorate the pinball machine to match a theme if you have chosen one.",

                          tools:
                              ["Laser Cutter", "Computers with 2D Vector Graphic Software", "Hot Glue Gun"],

                      }, {
                          summary: "PART G: Final Presentation ",
                          duration: "1800",
                          description: "   	Students present their pinball machines to the class.
                                                                                2.   	Students complete reflective memo for the project. (uploaded to folder)

                                                                                                                          Teacher Led Discussion:  Teacher will discuss levers and inclined planes, which are two of the simple machines.  In most cases simple machines are used to make our lives easier by requiring a smaller input force to get a larger output force.  In the case of the flipper, we sacrifice the force advantage to gain a larger range of motion.

                                                                                                                              The inclined plane is the playing field of the pinball machine.  By having an angle we increase the speed of the marble as it goes down the incline toward the flipper.  This makes the game more exciting and challenging."
                      }],


              standards:
                  [{
                       name: "Common Core English Language Arts/Science & Technical Subjects Standards",
                       descriptions: ["RST.9-10.3. Follow precisely a complex multistep procedure when carrying out experiments, taking measurements, or performing technical tasks, attending to special cases or exceptions defined in the text.", "RST.9-10.4. Determine the meaning of symbols, key terms, and other domain-specific words and phrases as they are used in a specific scientific or technical context relevant to grades 9-10 texts and topics.", "RST.9-10.5. Analyze the structure of the relationships among concepts in a text, including relationships among key terms (e.g., force, friction, reaction force, energy).", "RST.9-10.8. Assess the extent to which the reasoning and evidence in a text support the author's claim or a recommendation for solving a scientific or technical problem.", "RST.9-10.9. Compare and contrast findings presented in a text to those from other sources (including their own experiments), noting when the findings support or contradict previous explanations or accounts."]
                   },
                   {
                       name: "Common Core Mathematics Standards",
                       descriptions: ["HSN.Q.A.1: Use units as a way of understanding problems and to guide the solution of multi-step problems; choose and interpret units consistently in formulas; choose and interpret the scale and the origin in graphs and data displays.", "HSN.Q.A.2.: Define appropriate quantities for the purpose of descriptive modeling.", "HSN.Q.A.3: Choose a level of accuracy appropriate to limitations on measurements when reporting quantities.", "HSN.CED.A.2:  Create equations in two or more variables to represent relationship between quantities; graph equations on coordinate axes with labels and scales."]
                   },
                   {
                       name: "Common Core Social Studies Unifying Theme: Sequencing and Chronology Skills ",
                       descriptions: ["Using the vocabulary of time and place", "Placing events in chronological order", "Sequencing events on a timeline", "Creating timelines", "Understanding concepts of time, continuity, and change."]
                   },
                   {
                       name: "Major Next Generation Science Standards Understandings",
                       descriptions: ["Energy cannot be created or destroyed, but only changed from one form into another", "Mechanical energy can be considered either to be kinetic energy, which is energy in motion, or potential energy, which depends on relative position.", "Energy exists in many forms, and when these forms change, energy is conserved."]
                   },
                   {
                       name: "Next Generation Cross-Cutting Concepts",
                       descriptions: ["Time, space, and energy phenomena can be observed at various scales using models to study systems that are too large or too small.", "The total amount of energy and matter in closed systems is conserved.", "Energy drives the cycling of matter within and between systems.", "Proportional relationships (e.g. speed as the ratio of distance traveled to time taken) among different types of quantities provide information about the magnitude of properties and processes."]
                   },
                   {
                       name: "Digital Fabrication Competencies: I can statements",
                       descriptions: ["(FAB.1): The Design Process: I can use the digital fabrication design process and quality assurance principles to analyze and solve design problems. This includes journal writing to document progress and capture ideas during the development phase., purposes, and audiences", "(FAB.2): Sketching and Visualization: I can brainstorm, conceptualize and sketch design projects and components, by hand sketch. This includes paper prototyping", "(FAB.3): Create Models: I can create models to illustrate the design of project and components This include using and/or creating a file during the modeling process.", "(FAB.4): Interpret and prepare 2D and 3D drawings: I can create and interpret auxiliary views, orthographic projections, isometric drawing, oblique drawings and perspective drawings. I can also use 2D and 3D modeling software to document work and communicate solutions.", "(FAB.5): Computer-Aided Modeling: I can create models to illustrate the design of projects, including apply manufacturing processes (e.g. casting, molding, separating, assembling, finishing, and rapid prototyping).", "(FAB.6): Computer-Aided Drafting: I can interpret and prepare technical drawings, including creating and interpreting auxiliary views, orthographic projections, isometric drawings, oblique drawings and perspective drawings.", "(FAB.7): Precision Digital Fabrication Machining: I can apply principles of precision machining to measuring work pieces, drawing interpretations, and inspect workpieces according to specifications.", "(FAB.8): Measurement and Interpretation: I can interpret drawings and documentation and perform measurements.", "(FAB.9): Layout and Planning: I can determine product requirements, dimensions, and tolerances from drawing and specifications.", "(FAB.10): Implement safety procedures. I can demonstrate knowledge of FAB Lab safety rules and guidelines."]
                   }],

              grade_range: {start: 10, end: 13},
              subjects:
                  ["technology", "science", "engineering"],
              mastery_level:
                  {student: "3", educator: "3"},
              skills: [
                  {name: "CAD Design", level: "2"},
                  {name: "Laser Cutting", level: "2"}
              ],
              context:
                  ["In Classroom", "In fablab"],
              collection_tag: "fab certified/tested"
          }; steps = lesson.delete(:steps)
    end
    def quatcopter

      [{
           name: "Common Core ELA Writing Standards",
           descriptions: [ "RST.6–8.1 Cite specific textual evidence to support analysis of science and technical texts. (MS-ETS1-1),(MS-ETS1-2),(MS-ETS1-3)", "RST.6–8.7 Integrate quantitative or technical information expressed in words in a text with a version of that information expressed visually (e.g., in a flowchart, diagram, model, graph, or table). (MS-ETS1-3)", "RST.6–8.9 Compare and contrast the information gained from experiments, simulations, video, or multimedia sources with that gained from reading a text on the same topic. (MS-ETS1-2),(MS-ETS1-3)", "WHST.6–8.7 Conduct short research projects to answer a question (including a self-generated question), drawing on several sources and generating additional related, focused questions that allow for multiple avenues of exploration. (MS-ETS1-2)", "WHST.6–8.8 Gather relevant information from multiple print and digital sources (primary and secondary), using search terms         	effectively; assess the credibility and accuracy of each source; and quote or paraphrase the data and conclusions of others while avoiding plagiarism and following a standard format for citation. (MS-ETS1-1)", "WHST.6–8.9         	Draw evidence from informational texts to support analysis, reflection, and research. (MS-ETS1-2)", "SL.8.5                    	Include multimedia components and visual displays in presentations to clarify claims and findings and emphasize salient points. (MS-ETS1-4)"]
       },
       {
           name: "Common Core Math",
           descriptions: [ "MP.2 Reason abstractly and quantitatively. (MS-ETS1-1),(MS-ETS1-2),(MS-ETS1-3),(MS-ETS1-4)", "7.EE.3 Solve multi-step real-life and mathematical problems posed with positive and negative rational numbers in any form (whole numbers, fractions, and decimals), using tools strategically. Apply properties of operations to calculate with numbers in any form; convert between forms as appropriate; and assess the reasonableness of answers using mental computation and estimation strategies. (MS-ETS1-1),(MS-ETS1-2),(MS-ETS1-3)", "7.SP.7.a,b Develop a probability model and use it to find probabilities of events. Compare probabilities from a model to observed frequencies, if the agreement is not good, explain possible sources of the discrepancy (MS-ETS 1-4)"]
       },
       {
           name: "Next Generation Science Standards",
           descriptions: [ "MS-ETS1-1.  Define the criteria and constraints of a design problem with sufficient precision to ensure a successful solution, taking into account relevant scientific principles and potential impacts on people and the natural environment that may limit possible solutions.", "MS-ETS1-2.  Evaluate competing design solutions using a systematic process to determine how well they meet the criteria and constraints of the problem.", "MS-ETS1-3.  Analyze data from tests to determine similarities and differences among several design solutions to identify the best characteristics of each that can be combined into a new solution to better meet the criteria for success.", "MS-ETS1-4.  Develop a model to generate data for iterative testing and modification of a  proposed object, tool, or process such that an optimal design can be achieved"]
       },
       {
           name: "Digital Fabrication Competencies: I can statements",
           descriptions: [ "(FAB.1): The Design Process: I can use the digital fabrication design process and quality assurance principles to analyze and solve design problems. This includes journal writing to document progress and capture ideas during the development phase., purposes, and audiences", "(FAB.2): Sketching and Visualization: I can brainstorm, conceptualize and sketch design projects and components, by hand sketch includes paper prototyping.", "(FAB.3): Create Models: I can create models to illustrate the design of project and components This include using and/or creating a file during the modeling process.", "(FAB.4): Interpret and prepare 2D and 3D drawings: I can create and interpret auxiliary views, orthographic projections, isometric drawing, oblique drawings and perspective drawings. I can also use 2D and 3D modeling software to document work and communicate solutions.", "(FAB.5): Computer-Aided Modeling: I can create models to illustrate the design of projects, including apply manufacturing processes (e.g. casting, molding, separating, assembling, finishing, and rapid prototyping).", "(FAB.6): Computer-Aided Drafting: I can interpret and prepare technical drawings, including creating and interpreting auxiliary views, orthographic projections, isometric drawings, oblique drawings and perspective drawings.", "(FAB.7): Precision Digital Fabrication Machining: I can apply principles of precision machining to measuring work pieces, drawing interpretations, and inspect work pieces according to specifications.", "(FAB.8): Measurement and Interpretation: I can interpret drawings and documentation and perform measurements.","(FAB.9): Layout and Planning: I can determine product requirements, dimensions, and tolerances from drawing and specifications.", "(FAB.10): Implement safety procedures. I can demonstrate knowledge of FAB Lab safety rules and guidelines." ]
       }]

    end

  end
end
