import 'package:flutter/material.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/models/category.dart';
import 'package:kids_mart/models/course.dart';

const categories = [
  Category(
    'Educational Books',
    'Books',
    Icons.menu_book_rounded,
    Color(0xFFFFE7A8),
    id: 'books',
  ),
  Category(
    'Online Courses',
    'Courses',
    Icons.play_circle_rounded,
    Color(0xFFDCEEFF),
    id: 'courses',
  ),
  Category(
    'Learning Toys',
    'Toys',
    Icons.extension_rounded,
    Color(0xFFFFDAE1),
    id: 'toys',
  ),
  Category(
    'Flashcards',
    'Flashcards',
    Icons.style_rounded,
    Color(0xFFD1F4E8),
    id: 'flashcards',
  ),
];

const products = [
  Product(
    'Good Night Stories',
    'Age 3+',
    8.50,
    Icons.auto_stories_rounded,
    Color(0xFFFFE7A8),
    categoryId: 'books',
    id: 'good-night-stories',
  ),
  Product(
    'Building Blocks Set',
    'Age 4+',
    12.00,
    Icons.toys_rounded,
    Color(0xFFD1F4E8),
    categoryId: 'toys',
    id: 'building-blocks-set',
  ),
  Product(
    'Dinosaur World Book',
    'Age 3+',
    9.90,
    Icons.menu_book_rounded,
    Color(0xFFDCEEFF),
    categoryId: 'books',
    id: 'dinosaur-world-book',
  ),
  Product(
    'ABC Learning Book',
    'Age 2+',
    7.20,
    Icons.spellcheck_rounded,
    Color(0xFFFFDAE1),
    categoryId: 'books',
    id: 'abc-learning-book',
  ),
  Product(
    'Math Adventures',
    'Age 6+',
    14.00,
    Icons.calculate_rounded,
    Color(0xFFDCEEFF),
    categoryId: 'courses',
    id: 'math-adventures',
  ),
  Product(
    'First Words Flashcards',
    'Age 3+',
    6.50,
    Icons.style_rounded,
    Color(0xFFD1F4E8),
    categoryId: 'flashcards',
    id: 'first-words-flashcards',
  ),
];

const legacyProducts = [
  Product(
    'First Words Flash Cards',
    'AGES 3–5',
    8500,
    Icons.style_rounded,
    Color(0xFFFFE7A8),
  ),
  Product(
    'My Big Activity Book',
    'AGES 4–7',
    12000,
    Icons.draw_rounded,
    Color(0xFFD1F4E8),
  ),
  Product(
    'Little Scientist Kit',
    'AGES 7–10',
    24500,
    Icons.science_rounded,
    Color(0xFFDCEEFF),
  ),
  Product(
    'Myanmar Story Collection',
    'AGES 5–9',
    15000,
    Icons.auto_stories_rounded,
    Color(0xFFFFDAE1),
  ),
];

const courses = [
  Course(
    'Math Adventures',
    'Ages 6–9',
    12,
    Icons.calculate_rounded,
    Color(0xFFDCEEFF),
  ),
  Course(
    'Creative English',
    'Ages 5–8',
    10,
    Icons.translate_rounded,
    Color(0xFFFFE7A8),
  ),
  Course(
    'Young Coder Lab',
    'Ages 8–12',
    16,
    Icons.code_rounded,
    Color(0xFFD1F4E8),
  ),
];
