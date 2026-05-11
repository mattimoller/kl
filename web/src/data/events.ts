import type { ImageMetadata } from 'astro';

import sentrumTeam from '../assets/events/sentrumslopet-2026/team-finish.jpg';
import sentrumSmoke from '../assets/events/sentrumslopet-2026/oslo-smoke.jpg';
import sentrumCowbell from '../assets/events/sentrumslopet-2026/cheer-cowbell.jpg';
import sentrumFlag from '../assets/events/sentrumslopet-2026/cheer-flag.jpg';
import sentrumRunnerCheers from '../assets/events/sentrumslopet-2026/runner-cheers.jpg';

import hkJackets from '../assets/events/holmenkollstafetten-2026/jackets.jpg';
import hkTeamWarmup from '../assets/events/holmenkollstafetten-2026/team-warmup.jpg';
import hkRunner from '../assets/events/holmenkollstafetten-2026/runner-3803.jpg';
import hkRunnerAction from '../assets/events/holmenkollstafetten-2026/runner-action.jpg';
import hkFlagBearer from '../assets/events/holmenkollstafetten-2026/flag-bearer.jpg';
import hkCheering from '../assets/events/holmenkollstafetten-2026/cheering.jpg';

export type EventPhoto = {
  src: ImageMetadata;
  alt: string;
};

export type Event = {
  slug: string;
  title: string;
  date: string;
  blurb?: string;
  photos: EventPhoto[];
};

export const events: Event[] = [
  {
    slug: 'holmenkollstafetten-2026',
    title: 'Holmenkollstafetten',
    date: '2026-05-09',
    blurb: 'The classic Oslo relay — jackets on, flag up, full team on the track at Bislett.',
    photos: [
      { src: hkJackets, alt: 'Two KL members in matching white-and-blue jackets before the start' },
      { src: hkTeamWarmup, alt: 'KL teammates in caps and bibs huddled together before their leg' },
      { src: hkRunner, alt: 'A KL runner in race kit, mid-stride past the spring leaves' },
      { src: hkRunnerAction, alt: 'A KL runner mid-leg in a blue race singlet, film-grain action shot' },
      { src: hkFlagBearer, alt: 'A KL member waving the running flag on the Bislett infield' },
      { src: hkCheering, alt: 'The KL crew cheering from the trackside as a runner sprints past' },
    ],
  },
  {
    slug: 'sentrumslopet-2026',
    title: 'Sentrumsløpet',
    date: '2026-04-25',
    blurb: 'Blue smoke at City Hall, cowbells on the course, a team photo at the finish.',
    photos: [
      { src: sentrumTeam, alt: 'The KL Running team after Sentrumsløpet in Oslo' },
      { src: sentrumRunnerCheers, alt: 'A KL runner sprinting past the team cheering with flag and megaphone' },
      { src: sentrumSmoke, alt: 'Runners passing through blue smoke in front of Oslo City Hall' },
      { src: sentrumCowbell, alt: 'A KL member cheering on runners with a cowbell' },
      { src: sentrumFlag, alt: 'Cheering with the KL flag and megaphone as runners pass' },
    ],
  },
];
