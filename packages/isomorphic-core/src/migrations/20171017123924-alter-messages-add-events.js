/* eslint no-unused-vars: 0 */

module.exports = {
  up: function up(queryInterface, Sequelize) {
    return Sequelize.query("ALTER TABLE messages ADD events TEXT;");
  },
  down: function down(queryInterface, Sequelize) {
    return true;
  },
};
