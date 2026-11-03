import 'package:flutter/material.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/models/category.dart';
import 'package:jojo/models/course.dart';

const categories = [
  Category('Educational Books', 'Books',   Icons.menu_book_rounded,    Color(0xFFFFE7A8)),
  Category('Online Courses',    'Courses', Icons.play_circle_rounded,  Color(0xFFDCEEFF)),
  Category('Learning Toys',     'Toys',    Icons.extension_rounded,    Color(0xFFFFDAE1)),
  Category('Flashcards',        'Cards',   Icons.style_rounded,        Color(0xFFD1F4E8)),
  Category('Worksheets',        'Sheets',  Icons.description_rounded,  Color(0xFFE8E2FF)),
  Category('STEM & Science',    'STEM',    Icons.science_rounded,      Color(0xFFD8F2FF)),
  Category('Mathematics',       'Math',    Icons.calculate_rounded,    Color(0xFFFFE8C8)),
  Category('English',           'English', Icons.translate_rounded,    Color(0xFFDCEEFF)),
  Category('Arts & Creativity', 'Arts',    Icons.palette_rounded,      Color(0xFFFFDAE1)),
  Category('Coding for Kids',   'Coding',  Icons.code_rounded,         Color(0xFFD1F4E8)),
];

const products = [
  Product('Good Night Stories',  'Age 3+', 8.50,  Icons.auto_stories_rounded, Color(0xFFFFE7A8)),
  Product('Building Blocks Set', 'Age 4+', 12.00, Icons.toys_rounded,         Color(0xFFD1F4E8)),
  Product('Dinosaur World Book', 'Age 3+', 9.90,  Icons.menu_book_rounded,    Color(0xFFDCEEFF)),
  Product('ABC Learning Book',   'Age 2+', 7.20,  Icons.spellcheck_rounded,   Color(0xFFFFDAE1)),
];

const legacyProducts = [
  Product('First Words Flash Cards',  'AGES 3–5', 8500,  Icons.style_rounded,        Color(0xFFFFE7A8)),
  Product('My Big Activity Book',     'AGES 4–7', 12000, Icons.draw_rounded,         Color(0xFFD1F4E8)),
  Product('Little Scientist Kit',     'AGES 7–10', 24500, Icons.science_rounded,     Color(0xFFDCEEFF)),
  Product('Myanmar Story Collection', 'AGES 5–9', 15000, Icons.auto_stories_rounded, Color(0xFFFFDAE1)),
];

const courses = [
  Course('Math Adventures',  'Ages 6–9',  12, Icons.calculate_rounded, Color(0xFFDCEEFF)),
  Course('Creative English', 'Ages 5–8',  10, Icons.translate_rounded, Color(0xFFFFE7A8)),
  Course('Young Coder Lab',  'Ages 8–12', 16, Icons.code_rounded,      Color(0xFFD1F4E8)),
];
